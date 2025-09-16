import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import '../tables/reminders_table.dart';

/// Migration for version 13 - adds reminders table
Future<void> upgrade(Database db) async {
  AppLogger.info('Running migration v13: Adding reminders table');
  await RemindersTable.create(db);
  AppLogger.info('Migration v13 completed successfully');
}
