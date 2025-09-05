import 'package:tatbeeqi/features/courses_details.dart/data/datasources/mock_course_details_datasource.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/entities/course_details.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/repository/course_details_repository.dart';

class CourseDetailsRepositoryImpl implements CourseDetailsRepository {
  final MockCourseDetailsDataSource dataSource;

  CourseDetailsRepositoryImpl(this.dataSource);

  @override
  Future<CourseDetails> fetchCourseDetails(String courseId) async {
    // In a real implementation, you would filter by courseId
    return dataSource.courseDetails;
  }
}
