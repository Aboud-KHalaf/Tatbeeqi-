import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import '../tables/notifications_table.dart';

/// Migration for version 12 - adds notifications table
Future<void> upgrade(Database db) async {
  AppLogger.info('Running migration v12: Adding notifications table');
  await NotificationsTable.create(db);
  AppLogger.info('Migration v12 completed successfully');
}
