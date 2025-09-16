import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';

// Table name
const String remindersTableName = 'reminders';

// Column names
const String remindersColId = 'id';
const String remindersColDays = 'days'; // comma-separated string
const String remindersColHour = 'hour';
const String remindersColMinute = 'minute';
const String remindersColTitle = 'title';
const String remindersColBody = 'body';
const String remindersColIsActive = 'isActive'; // 0/1
const String remindersColCourseId = 'courseId';
const String remindersColCreatedAt = 'createdAt';

class RemindersTable {
  static Future<void> create(Database db) async {
    AppLogger.info('Creating database table: $remindersTableName');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $remindersTableName (
        $remindersColId TEXT PRIMARY KEY,
        $remindersColDays TEXT NOT NULL,
        $remindersColHour INTEGER NOT NULL,
        $remindersColMinute INTEGER NOT NULL,
        $remindersColTitle TEXT NOT NULL,
        $remindersColBody TEXT NOT NULL,
        $remindersColIsActive INTEGER NOT NULL DEFAULT 1,
        $remindersColCourseId TEXT,
        $remindersColCreatedAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_reminders_course
      ON $remindersTableName($remindersColCourseId)
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_reminders_active
      ON $remindersTableName($remindersColIsActive)
    ''');
    AppLogger.info('Table $remindersTableName created successfully.');
  }
}
