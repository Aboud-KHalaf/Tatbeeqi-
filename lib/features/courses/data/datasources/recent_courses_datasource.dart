import 'package:sqflite/sqflite.dart';
import 'package:tatbeeqi/core/services/database/database_service.dart';
import 'package:tatbeeqi/core/services/database/tables/recent_courses_table.dart';

abstract class RecentCoursesDataSource {
  Future<void> upsertVisit(String userId, int courseId, int lastVisit);
  Future<List<int>> getRecentCourseIds(String userId, {int limit = 5});
  Future<void> clearForUser(String userId);
  Future<void> deleteForUser(String userId, int courseId);
}

class RecentCoursesDataSourceImpl implements RecentCoursesDataSource {
  final DatabaseService databaseService;
  RecentCoursesDataSourceImpl({required this.databaseService});

  @override
  Future<void> upsertVisit(String userId, int courseId, int lastVisit) async {
    final db = await databaseService.database;
    await db.insert(
      recentCoursesTableName,
      {
        recentCoursesColUserId: userId,
        recentCoursesColCourseId: courseId,
        recentCoursesColLastVisit: lastVisit,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<int>> getRecentCourseIds(String userId, {int limit = 5}) async {
    final db = await databaseService.database;
    final rows = await db.query(
      recentCoursesTableName,
      columns: [recentCoursesColCourseId],
      where: '$recentCoursesColUserId = ?',
      whereArgs: [userId],
      orderBy: '$recentCoursesColLastVisit DESC',
      limit: limit,
    );
    return rows.map((e) => e[recentCoursesColCourseId] as int).toList();
  }

  @override
  Future<void> clearForUser(String userId) async {
    final db = await databaseService.database;
    await db.delete(
      recentCoursesTableName,
      where: '$recentCoursesColUserId = ?',
      whereArgs: [userId],
    );
  }

  @override
  Future<void> deleteForUser(String userId, int courseId) async {
    final db = await databaseService.database;
    await db.delete(
      recentCoursesTableName,
      where: '$recentCoursesColUserId = ? AND $recentCoursesColCourseId = ?',
      whereArgs: [userId, courseId],
    );
  }
}
