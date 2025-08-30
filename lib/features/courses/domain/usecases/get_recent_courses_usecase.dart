import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/domain/repositories/recent_courses_repository.dart';

class GetRecentCoursesUseCase {
  final RecentCoursesRepository repository;
  GetRecentCoursesUseCase(this.repository);

  Future<List<Course>> call(String userId, {int limit = 5}) {
    return repository.getRecentCourses(userId, limit: limit);
  }
}
