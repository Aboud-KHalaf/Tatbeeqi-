import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/services/notifications/fcm_service.dart';
import 'package:tatbeeqi/core/services/notifications/local_notifications_service.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'package:tatbeeqi/features/notifications/data/models/app_notification_model.dart';
import 'package:tatbeeqi/features/notifications/data/models/device_token_model.dart';

import '../../domain/entities/app_notification.dart';

abstract class NotificationsRemoteDatasource {
  // Initialization
  Future<Unit> initializeFirebaseNotifications();

  // Local notification display for Firebase messages
  Future<Unit> showFirebaseNotification(RemoteMessage message);

  // Topic subscriptions
  Future<Unit> subscribeToTopic(String topic);
  Future<Unit> unsubscribeFromTopic(String topic);

  // Device token management
  Future<String> getDeviceToken();
  Future<Unit> deleteDeviceToken();
  Future<Unit> registerDeviceToken({
    required String deviceToken,
    required String platform,
  });

  // Notifications
  Future<List<AppNotification>> getNotifications();
  Future<Unit> sendNotificationToTopics({
    required AppNotificationModel notification,
    required List<String> topics,
  });
  Future<Unit> sendNotificationToUsers({
    required AppNotificationModel notification,
    required List<String> userIds,
  });
}

class NotificationsRemoteDatasourceImpl
    implements NotificationsRemoteDatasource {
  final SupabaseClient supabaseClient;
  final FirebaseMessaging firebaseMessaging;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;

  NotificationsRemoteDatasourceImpl({
    required this.supabaseClient,
    required this.firebaseMessaging,
    required this.localNotificationsPlugin,
  });

  // =========================
  // Initialization
  // =========================
  @override
  Future<Unit> initializeFirebaseNotifications() async {
    try {
      await _ensureNotificationPermission();

      final permission = await firebaseMessaging.requestPermission();
      if (permission.authorizationStatus != AuthorizationStatus.authorized) {
        throw Exception('Notification permissions not granted');
      }

      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage
          .listen(onData, onDone: onDone, onError: onError);
      FirebaseMessaging.instance.onTokenRefresh.listen(onTokenRefreshed);

      // for (var topic in AppRemoteNotificationsSettings.defaultTopicList) {
      //   await subscribeToTopic(topic);
      // }

      AppLogger.info("Firebase notifications initialized.");
      return unit;
    } catch (e) {
      AppLogger.error("Firebase notification init error: $e");
      throw ServerException(e.toString());
    }
  }

  Future<void> _ensureNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  // =========================
  // Local Notifications (Firebase message display)
  // =========================
  @override
  Future<Unit> showFirebaseNotification(RemoteMessage message) async {
    final notification = AppNotificationModel.fromRemoteFCM(message);

    if (!notification.isValid()) return unit;

    await _showNotification(
      id: DateTime.now().millisecond,
      title: notification.title,
      body: notification.body,
      details: AppLocalNotificationsService.defaultNotificationsDetails(),
    );

    AppLogger.info("Firebase notification shown: ${notification.title}");
    return unit;
  }

  Future<void> _showNotification({
    required int id,
    required String title,
    String? body,
    required NotificationDetails details,
  }) async {
    await localNotificationsPlugin.show(id, title, body, details);
  }

  // =========================
  // Topic subscriptions
  // =========================
  @override
  Future<Unit> subscribeToTopic(String topic) async {
    await firebaseMessaging.subscribeToTopic(topic);
    AppLogger.info("Subscribed to topic: $topic");
    return unit;
  }

  @override
  Future<Unit> unsubscribeFromTopic(String topic) async {
    await firebaseMessaging.unsubscribeFromTopic(topic);
    AppLogger.info("Unsubscribed from topic: $topic");
    return unit;
  }

  // =========================
  // Device token management
  // =========================
  @override
  Future<String> getDeviceToken() async {
    final token = Platform.isIOS
        ? await firebaseMessaging.getAPNSToken()
        : await firebaseMessaging.getToken();

    if (token == null) {
      AppLogger.error("FCM token is null");
      throw Exception("FCM token is null");
    }
    AppLogger.info("Device token retrieved: $token");
    return token;
  }

  @override
  Future<Unit> deleteDeviceToken() async {
    await firebaseMessaging.deleteToken();
    AppLogger.info("Device token deleted");
    return unit;
  }

  @override
  Future<Unit> registerDeviceToken({
    required String deviceToken,
    required String platform,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      AppLogger.error("Cannot register device token: null user");
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
      AppLogger.info("Device token registered successfully");
      return unit;
    } on PostgrestException catch (e) {
      AppLogger.error('Supabase error: ${e.message}');
      throw ServerException(e.toString());
    } catch (e) {
      AppLogger.error('Unexpected error: $e');
      throw ServerException(e.toString());
    }
  }

  // =========================
  // Notifications
  // =========================
  @override
  Future<List<AppNotificationModel>> getNotifications() async {
    try {
      final response = await supabaseClient.from('notifications').select('*');
      return response
          .map((e) => AppNotificationModel.fromDatabaseJson(e))
          .toList();
    } catch (e) {
      AppLogger.error("Failed to fetch notifications: $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> sendNotificationToTopics({
    required AppNotificationModel notification,
    required List<String> topics,
  }) async {
    // TODO: implement Supabase function call
    AppLogger.info("sendNotificationToTopics called (stub)");
    return unit;
  }

  @override
  Future<Unit> sendNotificationToUsers({
    required AppNotificationModel notification,
    required List<String> userIds,
  }) async {
    // TODO: implement Supabase function call
    AppLogger.info("sendNotificationToUsers called (stub)");
    return unit;
  }
}
