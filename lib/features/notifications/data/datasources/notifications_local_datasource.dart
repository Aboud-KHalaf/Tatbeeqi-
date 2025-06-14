import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/features/notifications/data/mappers/app_notification_mapper.dart';

import '../../domain/entities/app_notification.dart';
import '../models/app_notification_model.dart';

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
  ///
  // final Database _database;

  NotificationsLocalDatasourceImplements();
  @override
  Future<int> insertNotification(
      {required AppNotification notification}) async {
    //
    // final int id = await _database.insert(
    //   'notifications_table',
    //   notification.toModel.toDatabaseJson(),
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // );
    // //
    // return id;
    return 1;
  }

  @override
  Future<int> deleteNotification({required int notificationId}) async {
    // final int id = await _database.delete(
    //   "notifications_table",
    //   where: "id = ?",
    //   whereArgs: [notificationId],
    // );
    return 1;
  }

  @override
  Future<List<AppNotification>> getNotifications() async {
    // //
    // await _database.update(
    //   'notifications_table',
    //   {"seen": 1},
    // );
    // //
    // List<Map<String, dynamic>> operationsJson = await _database.query(
    //   'notifications_table',
    //   orderBy: "date DESC",
    // );
    // //
    // List<AppNotification> operations = operationsJson.map((data) {
    //   return AppNotificationModel.fromDatabaseJson(data).toEntity;
    // }).toList();

    return [];
    // operations;
  }

  @override
  Future<Unit> clearNotifications() async {
    // await _database.delete(
    //   'notifications_table',
    // );
    return unit;
  }
}
