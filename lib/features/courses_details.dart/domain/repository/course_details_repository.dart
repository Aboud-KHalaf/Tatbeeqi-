import 'package:tatbeeqi/features/courses_details.dart/domain/entities/course_details.dart';

abstract class CourseDetailsRepository {
  Future<CourseDetails> fetchCourseDetails(int courseId);
}
