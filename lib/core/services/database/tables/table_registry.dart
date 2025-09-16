import 'package:sqflite/sqflite.dart';
import 'todos_table.dart';
import 'courses_table.dart';
import 'notes_table.dart';
import 'cached_posts_table.dart';
import 'cached_news_table.dart';
import 'notifications_table.dart';
import 'reminders_table.dart';
import 'recent_courses_table.dart';

/// Registry of all database tables
class TableRegistry {
  /// All table creation functions
  static final List<Future<void> Function(Database)> _tableCreators = [
    TodosTable.create,
    CoursesTable.create,
    NotesTable.create,
    CachedPostsTable.create,
    CachedNewsTable.create,
    NotificationsTable.create,
    RemindersTable.create,
    RecentCoursesTable.create,
  ];

  /// Creates all tables in the database
  static Future<void> createAllTables(Database db) async {
    for (final creator in _tableCreators) {
      await creator(db);
    }
  }
}
