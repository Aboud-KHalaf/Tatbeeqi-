import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/di/service_locator.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'package:tatbeeqi/features/notifications/data/models/app_notification_model.dart';
import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/display_firebase_notification_usecase.dart';
import 'package:tatbeeqi/firebase_options.dart';

/// Handles FCM messages when app is in background/terminated
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  if (!sl.isRegistered<DisplayFirebaseNotificationUsecase>()) {
    await init();
  }

  final repo = GetIt.instance<NotificationsRepository>();

  try {
    final notification = AppNotificationModel.fromEntity(
        AppNotificationModel.fromRemoteFCM(message));
    if (notification.isValid()) {
      await repo.displayNotification(
        notification: notification,
        oneTimeNotification: true,
      );
    }
  } on Failure catch (e) {
    AppLogger.error('Background handler error: ${e.message}');
  }
}

/// Handles notification taps from background/terminated state
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse? response) async {
  if (response?.payload == null) return;

  // Initialize app if needed
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final payload = _parseNotificationPayload(response!.payload!);
  // if (payload != null) {
  //   Navigator.of(GetIt.instance.get<GlobalKey<NavigatorState>>().currentContext!).pushNamed(
  //     payload.route,
  //     queryParameters: payload.parameters,
  //   );
  // }
}

/// Handles foreground FCM messages
void onData(RemoteMessage message) async {
  final repo = GetIt.instance<NotificationsRepository>();

  try {
    final notification = AppNotificationModel.fromEntity(
        AppNotificationModel.fromRemoteFCM(message));
    if (notification.isValid()) {
      await repo.displayNotification(
        notification: notification,
        oneTimeNotification: true,
      );
    }
  } on Failure catch (e) {
    AppLogger.error('Foreground handler error: ${e.message}');
    if (kDebugMode) rethrow;
  }
}

/// Handles FCM token refresh events
void onTokenRefreshed(String newToken) async {
  final repo = GetIt.instance<NotificationsRepository>();

  try {
    await repo.registerDeviceToken(
      deviceToken: newToken,
      platform: Platform.isAndroid ? "android" : 'ios',
    );
  } on Failure catch (e) {
    AppLogger.error('Token refresh error: ${e.message}');
  }
}

/// Error handling wrapper
void onError(Object error) {
  AppLogger.error('from FCM handers file : Error: \$error');
  if (kDebugMode) throw error;
}

/// Cleanup resources
void onDone() {
  AppLogger.debug('FCM stream closed');
}

// NotificationPayload? _parseNotificationPayload(String payload) {
//   try {
//     return NotificationPayload.fromJson(jsonDecode(payload));
//   } catch (e) {
//     return null;
//   }
// }

@immutable
class NotificationPayload {
  final String route;
  final Map<String, dynamic> parameters;

  const NotificationPayload({
    required this.route,
    this.parameters = const {},
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      route: json['route'] as String,
      parameters: json['parameters'] as Map<String, dynamic>? ?? {},
    );
  }
}
