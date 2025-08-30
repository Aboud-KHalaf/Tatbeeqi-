import 'package:tatbeeqi/features/courses/domain/repositories/recent_courses_repository.dart';

class TrackCourseVisitUseCase {
  final RecentCoursesRepository repository;
  TrackCourseVisitUseCase(this.repository);

  Future<void> call(String userId, int courseId, {DateTime? at}) {
    return repository.trackVisit(userId, courseId, at: at);
  }
}
