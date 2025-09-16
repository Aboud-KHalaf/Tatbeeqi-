import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';

// Table name
const String cachedPostsTableName = 'cached_posts';

// Column names
const String cachedPostsColId = 'id';
const String cachedPostsColAuthorId = 'author_id';
const String cachedPostsColAuthorName = 'author_name';
const String cachedPostsColAuthorAvatarUrl = 'author_avatar_url';
const String cachedPostsColText = 'text';
const String cachedPostsColImageUrl = 'image_url';
const String cachedPostsColCategories = 'categories'; // Stored as JSON string
const String cachedPostsColCreatedAt = 'created_at';
const String cachedPostsColLikesCount = 'likes_count';
const String cachedPostsColCommentsCount = 'comments_count';
const String cachedPostsColIsArticle = 'is_article';
const String cachedPostsColIsLiked = 'is_liked';
const String cachedPostsColTopics = 'topics';

class CachedPostsTable {
  static Future<void> create(Database db) async {
    AppLogger.info('Creating database table: $cachedPostsTableName');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $cachedPostsTableName (
      $cachedPostsColId TEXT PRIMARY KEY,
      $cachedPostsColAuthorId TEXT NOT NULL,
      $cachedPostsColAuthorName TEXT NOT NULL,
      $cachedPostsColAuthorAvatarUrl TEXT,
      $cachedPostsColText TEXT NOT NULL,
      $cachedPostsColImageUrl TEXT,
      $cachedPostsColCategories TEXT NOT NULL,
      $cachedPostsColTopics TEXT NOT NULL,
      $cachedPostsColCreatedAt TEXT NOT NULL,
      $cachedPostsColLikesCount INTEGER NOT NULL DEFAULT 0,
      $cachedPostsColCommentsCount INTEGER NOT NULL DEFAULT 0,
      $cachedPostsColIsArticle INTEGER NOT NULL DEFAULT 0,
      $cachedPostsColIsLiked INTEGER NOT NULL DEFAULT 0
    )
  ''');
    AppLogger.info('Table $cachedPostsTableName created successfully.');
  }
}
