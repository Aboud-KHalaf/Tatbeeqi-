import 'package:dartz/dartz.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/timezone.dart' as tz;

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
      onDidReceiveNotificationResponse: (response) {},
      onDidReceiveBackgroundNotificationResponse: (response) {},
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
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
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
