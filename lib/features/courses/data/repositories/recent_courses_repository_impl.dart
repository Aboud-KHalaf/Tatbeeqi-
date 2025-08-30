import 'package:tatbeeqi/features/courses/data/datasources/recent_courses_datasource.dart';
import 'package:tatbeeqi/features/courses/data/datasources/course_local_data_source.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/domain/repositories/recent_courses_repository.dart';

class RecentCoursesRepositoryImpl implements RecentCoursesRepository {
  final RecentCoursesDataSource dataSource;
  final CourseLocalDataSource courseLocal;

  RecentCoursesRepositoryImpl({
    required this.dataSource,
    required this.courseLocal,
  });

  @override
  Future<void> trackVisit(String userId, int courseId, {DateTime? at}) async {
    final ts = (at ?? DateTime.now()).millisecondsSinceEpoch;
    await dataSource.upsertVisit(userId, courseId, ts);
  }

  @override
  Future<List<Course>> getRecentCourses(String userId, {int limit = 5}) async {
    final ids = await dataSource.getRecentCourseIds(userId, limit: limit);
    if (ids.isEmpty) return [];
    final models = await courseLocal.getCoursesByIds(ids: ids);
    // Preserve order by recency based on ids order
    final byId = {for (final m in models) m.id: m};
    final ordered = <Course>[];
    for (final id in ids) {
      final m = byId[id];
      if (m != null) ordered.add(m);
    }
    return ordered;
  }

  @override
  Future<void> clearHistory(String userId) async {
    await dataSource.clearForUser(userId);
  }

  @override
  Future<void> removeOne(String userId, int courseId) async {
    await dataSource.deleteForUser(userId, courseId);
  }
}
