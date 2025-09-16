import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';

// Table name
const String notificationsTableName = 'notifications';

// Column names
const String notificationsColLocalId = 'local_id'; // local autoincrement id
const String notificationsColId = 'id'; // uuid from server
const String notificationsColTitle = 'title';
const String notificationsColBody = 'body';
const String notificationsColImageUrl = 'image_url';
const String notificationsColHtml = 'html';
const String notificationsColDate = 'date'; // ISO8601 string
const String notificationsColType = 'type';
const String notificationsColTargetUserIds = 'target_user_ids'; // json string
const String notificationsColTargetTopics = 'target_topics'; // json string
const String notificationsColSentBy = 'sent_by';
const String notificationsColCreatedAt = 'created_at';
const String notificationsColSeen = 'seen'; // 0/1

class NotificationsTable {
  static Future<void> create(Database db) async {
    AppLogger.info('Creating database table: $notificationsTableName');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $notificationsTableName (
        $notificationsColLocalId INTEGER PRIMARY KEY AUTOINCREMENT,
        $notificationsColId TEXT UNIQUE,
        $notificationsColTitle TEXT NOT NULL,
        $notificationsColBody TEXT,
        $notificationsColImageUrl TEXT,
        $notificationsColHtml TEXT,
        $notificationsColDate TEXT NOT NULL,
        $notificationsColType TEXT,
        $notificationsColTargetUserIds TEXT,
        $notificationsColTargetTopics TEXT,
        $notificationsColSentBy TEXT,
        $notificationsColCreatedAt TEXT,
        $notificationsColSeen INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_notifications_date
      ON $notificationsTableName($notificationsColDate DESC)
    ''');
    AppLogger.info('Table $notificationsTableName created successfully.');
  }
}
