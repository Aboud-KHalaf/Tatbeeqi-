import 'package:tatbeeqi/features/courses/domain/repositories/recent_courses_repository.dart';

class ClearRecentCoursesUseCase {
  final RecentCoursesRepository repository;
  ClearRecentCoursesUseCase(this.repository);

  Future<void> call(String userId) {
    return repository.clearHistory(userId);
  }
}
