import 'package:dartz/dartz.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/services/database/database_service.dart';
import 'package:tatbeeqi/core/services/database/tables/notifications_table.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'package:tatbeeqi/features/notifications/data/models/app_notification_model.dart';
import 'package:tatbeeqi/features/notifications/data/models/reminder_model.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/reminder.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../domain/entities/app_notification.dart';

abstract class NotificationsLocalDatasource {
  ///
  Future<List<AppNotification>> getNotifications();

  ///
  Future<Unit> clearNotifications();

  ///
  Future<int> insertNotification({required AppNotification notification});

  ///
  Future<int> deleteNotification({required int notificationId});

  // Reminder methods
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
  @override
  Future<int> insertNotification(
      {required AppNotification notification}) async {
    final Database db = await _dbService.database;
    final model = AppNotificationModel(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      imageUrl: notification.imageUrl,
      html: notification.html,
      date: notification.date,
      type: notification.type,
      targetUserIds: notification.targetUserIds,
      targetTopics: notification.targetTopics,
      sentBy: notification.sentBy,
      createdAt: notification.createdAt,
      seen: notification.seen,
    );
    final map = model.toDatabaseJson();
    try {
      // Use conflictAlgorithm replace to avoid duplicates by server id
      return await db.insert(
        notificationsTableName,
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      AppLogger.error('insertNotification error: $e');
      rethrow;
    }
  }

  @override
  Future<int> deleteNotification({required int notificationId}) async {
    final Database db = await _dbService.database;
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
    final Database db = await _dbService.database;
    try {
      final rows = await db.query(
        notificationsTableName,
        orderBy: '$notificationsColDate DESC',
      );
      return rows
          .map((m) => AppNotificationModel.fromDatabaseJson(m).copyWith())
          .toList();
    } catch (e) {
      AppLogger.error('getNotifications error: $e');
      rethrow;
    }
  }

  @override
  Future<Unit> clearNotifications() async {
    final Database db = await _dbService.database;
    try {
      await db.delete(notificationsTableName);
      return unit;
    } catch (e) {
      AppLogger.error('clearNotifications error: $e');
      rethrow;
    }
  }

  // Reminder implementations
  @override
  Future<void> scheduleReminder(Reminder reminder) async {
    final Database db = await _dbService.database;
    final model = ReminderModel.fromEntity(reminder);

    try {
      // Save reminder to database
      await db.insert(
        'reminders',
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Schedule local notifications for each day

      for (int day in reminder.days) {
        final notificationId = _generateNotificationId(reminder.id, day);

        await _localNotificationsPlugin.zonedSchedule(
          notificationId,
          reminder.title,
          reminder.body,
          _nextInstanceOfWeekday(day, reminder.hour, reminder.minute),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'reminders_channel',
              'Study Reminders',
              channelDescription: 'Notifications for study reminders',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    } catch (e) {
      AppLogger.error('scheduleReminder error: $e');
      rethrow;
    }
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    final Database db = await _dbService.database;

    try {
      // Get reminder to cancel all its notifications
      final reminderData = await db.query(
        'reminders',
        where: 'id = ?',
        whereArgs: [reminderId],
      );

      if (reminderData.isNotEmpty) {
        final reminder = ReminderModel.fromJson(reminderData.first);

        // Cancel all scheduled notifications for this reminder
        for (int day in reminder.days) {
          final notificationId = _generateNotificationId(reminderId, day);
          await _localNotificationsPlugin.cancel(notificationId);
        }
      }

      // Delete from database
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
    final Database db = await _dbService.database;

    try {
      final List<Map<String, dynamic>> rows;

      if (courseId != null) {
        rows = await db.query(
          'reminders',
          where: 'courseId = ?',
          whereArgs: [courseId],
          orderBy: 'createdAt DESC',
        );
      } else {
        rows = await db.query(
          'reminders',
          orderBy: 'createdAt DESC',
        );
      }

      return rows.map((row) => ReminderModel.fromJson(row)).toList();
    } catch (e) {
      AppLogger.error('getReminders error: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    // Cancel existing reminder first
    await cancelReminder(reminder.id);
    // Schedule updated reminder
    await scheduleReminder(reminder);
  }

  // Helper methods
  int _generateNotificationId(String reminderId, int day) {
    return '${reminderId.hashCode}$day'.hashCode.abs() % 2147483647;
  }

  tz.TZDateTime _nextInstanceOfWeekday(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // Adjust weekday (1-7 Monday to Sunday) to DateTime weekday (1-7 Monday to Sunday)
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // If the scheduled time has passed today, schedule for next week
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }
}
