import 'package:tatbeeqi/features/courses/domain/repositories/recent_courses_repository.dart';

class RemoveRecentCourseUseCase {
  final RecentCoursesRepository repository;
  RemoveRecentCourseUseCase(this.repository);

  Future<void> call(String userId, int courseId) {
    return repository.removeOne(userId, courseId);
  }
}
