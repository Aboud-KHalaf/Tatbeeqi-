import 'package:tatbeeqi/features/courses_content/data/datasources/mock_course_details_datasource.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/course_details.dart';
import 'package:tatbeeqi/features/courses_content/domain/repositories/course_details_repository.dart';

class CourseDetailsRepositoryImpl implements CourseDetailsRepository {
  final MockCourseDetailsDataSource dataSource;

  CourseDetailsRepositoryImpl(this.dataSource);

  @override
  Future<CourseDetails> fetchCourseDetails(String courseId) async {
    // In a real implementation, you would filter by courseId
    return dataSource.courseDetails;
  }
}
