import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';

abstract class RecentCoursesRepository {
  Future<void> trackVisit(String userId, int courseId, {DateTime? at});
  Future<List<Course>> getRecentCourses(String userId, {int limit = 5});
  Future<void> clearHistory(String userId);
  Future<void> removeOne(String userId, int courseId);
}
