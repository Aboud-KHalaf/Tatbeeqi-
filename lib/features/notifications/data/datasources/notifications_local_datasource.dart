import 'package:dartz/dartz.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/services/database/database_service.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'package:tatbeeqi/features/notifications/data/models/app_notification_model.dart';

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
}

class NotificationsLocalDatasourceImplements
    implements NotificationsLocalDatasource {
  final DatabaseService _dbService;

  NotificationsLocalDatasourceImplements(this._dbService);
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
}
