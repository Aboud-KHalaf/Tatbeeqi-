import 'package:tatbeeqi/features/courses_content/domain/entities/course_details.dart';
import 'package:tatbeeqi/features/courses_content/domain/repositories/course_details_repository.dart';

class FetchCourseDetailsUseCase {
  final CourseDetailsRepository repository;

  FetchCourseDetailsUseCase(this.repository);

  Future<CourseDetails> call(String courseId) {
    return repository.fetchCourseDetails(courseId);
  }
}
