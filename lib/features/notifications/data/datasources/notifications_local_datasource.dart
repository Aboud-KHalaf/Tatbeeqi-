import 'package:dartz/dartz.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/services.dart';

import 'package:tatbeeqi/core/services/database/database_service.dart';
import 'package:tatbeeqi/core/services/database/tables/notifications_table.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'package:tatbeeqi/features/notifications/data/models/app_notification_model.dart';
import 'package:tatbeeqi/features/notifications/data/models/reminder_model.dart';
import 'package:tatbeeqi/core/services/notifications/local_notifications_service.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/app_notification.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/reminder.dart';

abstract class NotificationsLocalDatasource {
  // =========================
  // Local notifications init & controls
  // =========================
  Future<Unit> initializeLocalNotifications();
  Future<Unit> createNotificationChannel(AndroidNotificationChannel channel);
  Future<Unit> cancelNotification(int id);
  Future<Unit> showLocalNotification({
    required AppNotificationModel notification,
    bool oneTimeNotification,
    NotificationDetails? details,
  });

  // =========================
  // Notifications
  // =========================
  Future<List<AppNotification>> getNotifications();
  Future<Unit> clearNotifications();
  Future<int> insertNotification({required AppNotification notification});
  Future<int> deleteNotification({required int notificationId});

  // =========================
  // Reminders
  // =========================
  Future<void> scheduleReminder(Reminder reminder);
  Future<void> cancelReminder(String reminderId);
  Future<List<Reminder>> getReminders({String? courseId});
  Future<void> updateReminder(Reminder reminder);
}

class NotificationsLocalDatasourceImplements
    implements NotificationsLocalDatasource {
  final DatabaseService _dbService;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  NotificationsLocalDatasourceImplements(
    this._dbService,
    this._localNotificationsPlugin,
  );

  // =========================
  // Local notifications init & controls
  // =========================
  @override
  Future<Unit> initializeLocalNotifications() async {
    await _ensureNotificationPermission();
    await _createAllNotificationChannels();

    await _localNotificationsPlugin.initialize(
      AppLocalNotificationsService.settings,
      onDidReceiveNotificationResponse: notificationTapForeground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    AppLogger.info("Local notifications initialized (local datasource).");
    return unit;
  }

  @override
  Future<Unit> createNotificationChannel(
      AndroidNotificationChannel channel) async {
    final androidImpl =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(channel);
    AppLogger.info("Notification channel created (local): ${channel.id}");
    return unit;
  }

  @override
  Future<Unit> cancelNotification(int id) async {
    await _localNotificationsPlugin.cancel(id);
    AppLogger.info("Notification canceled (local): $id");
    return unit;
  }

  @override
  Future<Unit> showLocalNotification({
    required AppNotificationModel notification,
    bool oneTimeNotification = true,
    NotificationDetails? details,
  }) async {
    if (!notification.isValid()) return unit;

    await _localNotificationsPlugin.show(
      notification.id.hashCode,
      notification.title,
      notification.body,
      details ?? AppLocalNotificationsService.defaultNotificationsDetails(),
    );

    AppLogger.info(
        "Local notification shown (local datasource): ${notification.title}");
    return unit;
  }

  // =========================
  // Notifications methods
  // =========================
  @override
  Future<int> insertNotification(
      {required AppNotification notification}) async {
    final db = await _dbService.database;
    final model = AppNotificationModel.fromEntity(notification);

    try {
      return await db.insert(
        notificationsTableName,
        model.toDatabaseJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      AppLogger.error('insertNotification error: $e');
      rethrow;
    }
  }

  @override
  Future<int> deleteNotification({required int notificationId}) async {
    final db = await _dbService.database;
    try {
      return await db.delete(
        notificationsTableName,
        where: '$notificationsColLocalId = ?',
        whereArgs: [notificationId],
      );
    } catch (e) {
      AppLogger.error('deleteNotification error: $e');
      rethrow;
    }
  }

  @override
  Future<List<AppNotification>> getNotifications() async {
    final db = await _dbService.database;
    try {
      final rows = await db.query(
        notificationsTableName,
        orderBy: '$notificationsColDate DESC',
      );
      return rows
          .map((row) => AppNotificationModel.fromDatabaseJson(row).copyWith())
          .toList();
    } catch (e) {
      AppLogger.error('getNotifications error: $e');
      rethrow;
    }
  }

  @override
  Future<Unit> clearNotifications() async {
    final db = await _dbService.database;
    try {
      await db.delete(notificationsTableName);
      return unit;
    } catch (e) {
      AppLogger.error('clearNotifications error: $e');
      rethrow;
    }
  }

  // =========================
  // Reminders methods
  // =========================
  // Test method to verify notifications work
  Future<void> testNotification() async {
    try {
      AppLogger.info('=== TESTING NOTIFICATION ===');
      await _ensureNotificationPermission();

      final testTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

      await _localNotificationsPlugin.zonedSchedule(
        929899, // Test notification ID
        'Test Notification',
        'This is a test notification to verify the system works',
        testTime,
        AppLocalNotificationsService.remindersNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      AppLogger.info('✅ Test notification scheduled for: $testTime');

      // Log pending notifications to verify it is scheduled with the plugin
      await _logPendingNotifications();
    } catch (e) {
      AppLogger.error('❌ Test notification failed: $e');
    }
  }

  // Debug helper to list pending scheduled notifications
  Future<void> _logPendingNotifications() async {
    try {
      final pending = await _localNotificationsPlugin.pendingNotificationRequests();
      AppLogger.info('📋 Pending notifications count: ${pending.length}');
      for (final p in pending) {
        AppLogger.info('• Pending -> id: ${p.id}, title: ${p.title}, body: ${p.body}, payload: ${p.payload}');
      }
    } catch (e) {
      AppLogger.error('❌ Failed to fetch pending notifications: $e');
    }
  }

  @override
  Future<void> scheduleReminder(Reminder reminder) async {


    final db = await _dbService.database;
    final model = ReminderModel.fromEntity(reminder);

    try {
      // Save reminder to DB
      await db.insert(
        'reminders',
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      AppLogger.info('✅ Reminder saved to database');

      // Schedule local notifications for each day
      for (int day in reminder.days) {
        final notificationId = _generateNotificationId(reminder.id, day);
        final scheduledTime =
            _nextInstanceOfWeekday(day, reminder.hour, reminder.minute);


        try {
          await _localNotificationsPlugin.zonedSchedule(
            notificationId,
            reminder.title,
            reminder.body,
            scheduledTime,
            AppLocalNotificationsService.remindersNotificationDetails(),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          );
          AppLogger.info('✅ Notification scheduled successfully for day $day');
        } on PlatformException catch (e) {
          // Android 12+ may block exact alarms unless user grants permission.
          if (e.code == 'exact_alarms_not_permitted') {
            AppLogger.error(
                'Exact alarms not permitted. Falling back to inexact for notificationId=$notificationId');
            // Fallback: schedule as inexact so the reminder still works.
            await _localNotificationsPlugin.zonedSchedule(
              notificationId,
              reminder.title,
              reminder.body,
              scheduledTime,
              AppLocalNotificationsService.remindersNotificationDetails(),
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
              matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            );
            AppLogger.info('✅ Fallback notification scheduled for day $day');
          } else {
            AppLogger.error(
                '❌ scheduleReminder platform error: ${e.code} ${e.message}');
            rethrow;
          }
        } catch (e) {
          AppLogger.error(
              '❌ Unexpected error scheduling notification for day $day: $e');
          rethrow;
        }
      }
      AppLogger.info('=== SCHEDULING REMINDER COMPLETED ===');
    } catch (e) {
      AppLogger.error('❌ scheduleReminder error: $e');
      rethrow;
    }
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    final db = await _dbService.database;
    try {
      final reminderData = await db.query(
        'reminders',
        where: 'id = ?',
        whereArgs: [reminderId],
      );

      if (reminderData.isNotEmpty) {
        final reminder = ReminderModel.fromJson(reminderData.first);

        for (int day in reminder.days) {
          await _localNotificationsPlugin.cancel(
            _generateNotificationId(reminderId, day),
          );
        }
      }

      await db.delete(
        'reminders',
        where: 'id = ?',
        whereArgs: [reminderId],
      );
    } catch (e) {
      AppLogger.error('cancelReminder error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Reminder>> getReminders({String? courseId}) async {
    final db = await _dbService.database;
    try {
      final List<Map<String, dynamic>> rows = courseId != null
          ? await db.query(
              'reminders',
              where: 'courseId = ?',
              whereArgs: [courseId],
              orderBy: 'createdAt DESC',
            )
          : await db.query(
              'reminders',
              orderBy: 'createdAt DESC',
            );

      return rows.map((row) => ReminderModel.fromJson(row)).toList();
    } catch (e) {
      AppLogger.error('getReminders error: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    await cancelReminder(reminder.id);
    await scheduleReminder(reminder);
  }

  // =========================
  // Helper methods
  // =========================
  Future<void> _ensureNotificationPermission() async {
    AppLogger.info('Checking notification permissions...');
    var status = await Permission.notification.status;
    AppLogger.info('Notification permission status: $status');

    if (status.isDenied) {
      AppLogger.info('Requesting notification permission...');
      final result = await Permission.notification.request();
      AppLogger.info('Notification permission request result: $result');
    } else if (status.isPermanentlyDenied) {
      AppLogger.error(
          'Notification permission permanently denied, opening settings');
      await openAppSettings();
    }

    // Check exact alarm permission for Android 12+
    if (await _isAndroid12OrHigher()) {
      await _ensureExactAlarmPermission();
    }
  }

  Future<bool> _isAndroid12OrHigher() async {
    try {
      // This is a simple check - in a real app you might want to use device_info_plus
      return true; // Assume Android 12+ for safety
    } catch (e) {
      return false;
    }
  }

  Future<void> _ensureExactAlarmPermission() async {
    AppLogger.info('Checking exact alarm permissions...');
    try {
      final status = await Permission.scheduleExactAlarm.status;
      AppLogger.info('Exact alarm permission status: $status');

      if (status.isDenied) {
        AppLogger.info('Requesting exact alarm permission...');
        final result = await Permission.scheduleExactAlarm.request();
        AppLogger.info('Exact alarm permission request result: $result');

        if (result.isDenied || result.isPermanentlyDenied) {
          AppLogger.error(
              'Exact alarm permission denied - notifications may not work reliably');
        }
      }
    } catch (e) {
      AppLogger.error('Error checking exact alarm permission: $e');
    }
  }

  Future<void> _createAllNotificationChannels() async {
    for (var channel in AppLocalNotificationsService.channels) {
      await createNotificationChannel(channel);
    }
  }

  int _generateNotificationId(String reminderId, int day) {
    return '${reminderId.hashCode}$day'.hashCode.abs() % 2147483647;
  }

  tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }
}
