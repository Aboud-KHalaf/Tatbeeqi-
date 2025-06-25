import 'package:tatbeeqi/features/courses_content/domain/entities/course_details.dart';

abstract class CourseDetailsRepository {
  Future<CourseDetails> fetchCourseDetails(String courseId);
}
