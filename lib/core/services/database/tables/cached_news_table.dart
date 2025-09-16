import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';

// Table name
const String cachedNewsTableName = 'cached_news';

// Column names
const String cachedNewsColId = 'id';
const String cachedNewsColTitle = 'title';
const String cachedNewsColContent = 'content';
const String cachedNewsColImageUrl = 'image_url';
const String cachedNewsColAuthor = 'author';
const String cachedNewsColPublicationDate = 'publication_date';
const String cachedNewsColCategory = 'category';
const String cachedNewsColDescription = 'description';

class CachedNewsTable {
  static Future<void> create(Database db) async {
    AppLogger.info('Creating database table: $cachedNewsTableName');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $cachedNewsTableName (
        $cachedNewsColId TEXT PRIMARY KEY,
        $cachedNewsColTitle TEXT NOT NULL,
        $cachedNewsColContent TEXT NOT NULL,
        $cachedNewsColImageUrl TEXT,
        $cachedNewsColAuthor TEXT,
        $cachedNewsColPublicationDate TEXT NOT NULL,
        $cachedNewsColCategory TEXT,
        $cachedNewsColDescription TEXT
      )
    ''');
    AppLogger.info('Table $cachedNewsTableName created successfully.');
  }
}
