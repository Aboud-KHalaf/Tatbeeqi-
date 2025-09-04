import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/features/notifications/data/handlers/firebase_messaging_handlers.dart';
import 'package:tatbeeqi/features/notifications/data/models/app_notification_model.dart';
import 'package:tatbeeqi/features/notifications/data/models/device_token_model.dart';
import 'package:tatbeeqi/features/notifications/data/settings/app_local_notifications_settings.dart';
import 'package:tatbeeqi/features/notifications/data/settings/firebase_messaging_settings.dart';

import '../../domain/entities/app_notification.dart';

abstract class NotificationsRemoteDatasource {
  Future<Unit> initializeLocalNotification();
  Future<Unit> initializeFirebaseNotification();
  Future<Unit> cancelNotification(int id);
  Future<Unit> createNotificationsChannel(AndroidNotificationChannel channel);
  Future<Unit> displayFirebaseNotification(RemoteMessage message);
  Future<Unit> displayLocalNotification({
    required AppNotification notification,
    bool oneTimeNotification = true,
    NotificationDetails? details,
  });
  Future<Unit> subscribeToTopic(String topic);
  Future<Unit> unsubscribeToTopic(String topic);
  Future<String> getDeviceToken();
  Future<Unit> deleteDeviceToken();
  Future<Unit> registerDeviceToken(
      {required String deviceToken, required String platform});

  /// Sends a notification to a list of topics.
  Future<Unit> sendNotificationToTopics({
    required AppNotification notification,
    required List<String> topics,
  });

  /// Sends a notification to a list of user IDs.
  Future<Unit> sendNotificationToUsers({
    required AppNotification notification,
    required List<String> userIds,
  });

  Future<List<AppNotification>> getNotifications();
}

class NotificationsRemoteDatasourceImpl
    implements NotificationsRemoteDatasource {
  final SupabaseClient supabaseClient;
  final FirebaseMessaging firebaseMessaging;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;

  NotificationsRemoteDatasourceImpl(
      {required this.supabaseClient,
      required this.firebaseMessaging,
      required this.localNotificationsPlugin});

  @override
  Future<Unit> initializeLocalNotification() async {
    await _requestNotificationPermission();

    for (var channel in AppLocalNotificationsSettings.channels) {
      await createNotificationsChannel(channel);
    }

    await localNotificationsPlugin.initialize(
      AppLocalNotificationsSettings.settings,
      onDidReceiveNotificationResponse: (response) {},
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    return unit;
  }

  @override
  Future<Unit> initializeFirebaseNotification() async {
    try {
      await _requestNotificationPermission();
      final permission = await firebaseMessaging.requestPermission();
      if (permission.authorizationStatus != AuthorizationStatus.authorized) {
        throw Exception('Notification permissions not granted');
      }

      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: AppRemoteNotificationsSettings.showAlert,
        badge: AppRemoteNotificationsSettings.showBadge,
        sound: AppRemoteNotificationsSettings.showSound,
      );

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage
          .listen(onData, onDone: onDone, onError: onError);
      FirebaseMessaging.instance.onTokenRefresh.listen(onTokenRefreshed);

      for (var topic in AppRemoteNotificationsSettings.defaultTopicList) {
        await subscribeToTopic(topic);
      }

      //AppLogger.warning("Firebase token: ${await getDeviceToken()}");

      return unit;
    } catch (e) {
//      AppLogger.error("from remote FCM :  ${e.toString()} ");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> createNotificationsChannel(
      AndroidNotificationChannel channel) async {
    final androidImplementation =
        localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.createNotificationChannel(channel);
    return unit;
  }

  @override
  Future<Unit> cancelNotification(int id) async {
    await localNotificationsPlugin.cancel(id);
    return unit;
  }

  @override
  Future<Unit> displayLocalNotification({
    required AppNotification notification,
    bool oneTimeNotification = true,
    NotificationDetails? details,
  }) async {
    if (!notification.isValid()) return unit;

    await localNotificationsPlugin.show(
      notification.id.length,
      notification.title,
      notification.body,
      details ?? AppLocalNotificationsSettings.defaultNotificationsDetails(),
    );

    return unit;
  }

  @override
  Future<Unit> displayFirebaseNotification(RemoteMessage message) async {
    final notification = AppNotificationModel.fromRemoteFCM(message);
    debugPrint(notification.toString());

    if (message.notification?.title != null || !notification.isValid()) {
      return unit;
    }

    await localNotificationsPlugin.show(
      DateTime.now().millisecond,
      notification.title,
      notification.body,
      AppLocalNotificationsSettings.defaultNotificationsDetails(),
    );

    return unit;
  }

  @override
  Future<Unit> subscribeToTopic(String topic) async {
    await firebaseMessaging.subscribeToTopic(topic);
    return unit;
  }

  @override
  Future<Unit> unsubscribeToTopic(String topic) async {
    await firebaseMessaging.unsubscribeFromTopic(topic);
    return unit;
  }

  @override
  Future<Unit> deleteDeviceToken() async {
    await firebaseMessaging.deleteToken();
    return unit;
  }

  @override
  Future<String> getDeviceToken() async {
    final token = Platform.isIOS
        ? await firebaseMessaging.getAPNSToken()
        : await firebaseMessaging.getToken();

    if (token == null) throw Exception("FCM token is null");
    return token;
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Future<Unit> registerDeviceToken(
      {required String deviceToken, required String platform}) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      debugPrint('User is null');
      throw ServerException("null user");
    }

    final model = DeviceTokenModel.create(
      userId: user.id,
      deviceToken: deviceToken,
      platform: platform,
    );

    try {
      await supabaseClient
          .from('device_tokens')
          .delete()
          .eq('user_id', model.userId)
          .eq('platform', model.platform);

      await supabaseClient.from('device_tokens').insert(model.toMap());
      debugPrint("✅ Device token registered successfully to Supabase");
      return unit;
    } on PostgrestException catch (e) {
      debugPrint('Supabase error: ${e.message}');
      throw ServerException(e.toString());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await supabaseClient.from('notifications').select('*');
      return response.map((e) => AppNotificationModel.fromDatabaseJson(e)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> sendNotificationToTopics({
    required AppNotification notification,
    required List<String> topics,
  }) async {
    // print("from noti remote send topic");
    // return _invokeNotificationFunction(
    //   functionName: 'send-notifications-to-topics',
    //   body: {
    //     'topics': topics,
    //     'notification': notification.toDatabaseJson(),
    //   },
    //   errorContext: 'send notification to topics',
    // );
    return unit;
  }

  @override
  Future<Unit> sendNotificationToUsers({
    required AppNotification notification,
    required List<String> userIds,
  }) async {
    // return _invokeNotificationFunction(
    //   functionName: 'send-notifications-to-users',
    //   body: {
    //     'userIds': userIds,
    //     'notification': notification.toJson(),
    //   },
    //   errorContext: 'send notification to users',
    // );
    return unit;
  }

  /// A reusable method for invoking Supabase edge functions.
  // Future<Unit> _invokeNotificationFunction({
  //   required String functionName,
  //   required Map<String, dynamic> body,
  //   required String errorContext,
  // }) async {
  //   try {
  //     final response = await supabaseClient.functions.invoke(
  //       functionName,
  //       body: body,
  //     );

  //     if (response.status != 200) {
  //       final data = response.data as Map<String, dynamic>?;
  //       final errorMessage = data?['error']?['message'] ??
  //           data?['message'] ??
  //           'Unknown error from function';
  //       print('[$functionName] Failed: $errorMessage');
  //       throw Exception('Failed to $errorContext: $errorMessage');
  //     }

  //     print('[$functionName] Success: ${response.data}');
  //     return unit;
  //   } on FunctionException catch (e) {
  //     print('[$functionName] FunctionException: ${e.toString()}');
  //     print('Details: ${e.details}');
  //     throw Exception('Failed to $errorContext: ${e.toString()}');
  //   } catch (e) {
  //     print('[$functionName] Unexpected error: $e');
  //     throw Exception('Unexpected error while trying to $errorContext.');
  //   }
  // }
}
