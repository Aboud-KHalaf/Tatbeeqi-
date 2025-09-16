import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'courses_table.dart';

// Table name
const String recentCoursesTableName = 'recent_courses';

// Column names
const String recentCoursesColId = 'id';
const String recentCoursesColUserId = 'user_id';
const String recentCoursesColCourseId = 'course_id';
const String recentCoursesColLastVisit = 'last_visit';

class RecentCoursesTable {
  static Future<void> create(Database db) async {
    AppLogger.info('Creating database table: $recentCoursesTableName');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $recentCoursesTableName (
        $recentCoursesColId INTEGER PRIMARY KEY AUTOINCREMENT,
        $recentCoursesColUserId TEXT NOT NULL,
        $recentCoursesColCourseId INTEGER NOT NULL,
        $recentCoursesColLastVisit INTEGER NOT NULL,
        UNIQUE($recentCoursesColUserId, $recentCoursesColCourseId) ON CONFLICT REPLACE,
        FOREIGN KEY($recentCoursesColCourseId) REFERENCES $coursesTableName($coursesColId)
      )
    ''');
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_recent_courses_user_last
      ON $recentCoursesTableName($recentCoursesColUserId, $recentCoursesColLastVisit DESC)
    ''');
    AppLogger.info('Table $recentCoursesTableName created successfully.');
  }
}
