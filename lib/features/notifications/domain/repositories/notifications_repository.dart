import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/app_notification.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/reminder.dart';

abstract class NotificationsRepository {
  // 1️⃣ Initialization / Setup
  Future<Either<Failure, Unit>> initializeLocalNotifications();
  Future<Either<Failure, Unit>> initializeFirebaseNotifications();
  Future<Either<Failure, Unit>> createNotificationChannel({
    required AndroidNotificationChannel channel,
  });

  // 2️⃣ Device Token Management
  Future<Either<Failure, String>> getDeviceToken();
  Future<Either<Failure, String>> refreshDeviceToken();
  Future<Either<Failure, Unit>> deleteDeviceToken();
  Future<Either<Failure, Unit>> registerDeviceToken({
    required String deviceToken,
    required String platform,
  });

  // 3️⃣ Topic Subscription
  Future<Either<Failure, Unit>> subscribeToTopic({required String topic});
  Future<Either<Failure, Unit>> unsubscribeFromTopic({required String topic});

  // 4️⃣ Notifications Management
  Future<Either<Failure, List<AppNotification>>> getNotifications();
  Future<Either<Failure, Unit>> clearNotifications();
  Future<Either<Failure, Unit>> displayNotification({
    required AppNotification notification,
    bool oneTimeNotification = false,
    NotificationDetails? details,
  });
  Future<Either<Failure, Unit>> deleteNotification(
      {required int notificationId});
  Future<Either<Failure, Unit>> cancelNotification({required int id});
  Future<Either<Failure, Unit>> displayFirebaseNotification({
    required RemoteMessage message,
  });

  // 5️⃣ Sending Notifications
  Future<Either<Failure, Unit>> sendNotificationToTopics({
    required AppNotification notification,
    required List<String> topics,
  });
  Future<Either<Failure, Unit>> sendNotificationToUsers({
    required AppNotification notification,
    required List<String> userIds,
  });

  // 6️⃣ Reminders Management
  Future<void> scheduleReminder(Reminder reminder);
  Future<void> cancelReminder(String reminderId);
  Future<void> updateReminder(Reminder reminder);
  Future<List<Reminder>> getReminders({String? courseId});
}
