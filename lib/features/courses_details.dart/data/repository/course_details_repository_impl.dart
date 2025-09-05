import 'package:tatbeeqi/core/network/network_info.dart';
import 'package:tatbeeqi/features/courses_details.dart/data/datasources/course_details_remote_datasource.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/entities/course_details.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/repository/course_details_repository.dart';

class CourseDetailsRepositoryImpl implements CourseDetailsRepository {
  final CourseDetailsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CourseDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<CourseDetails> fetchCourseDetails(int courseId) async {
    final isConnected = await networkInfo.isConnected();
    if (isConnected) {
      return await remoteDataSource.fetchCourseDetails(courseId);
    } else {
      throw Exception('No internet connection');
    }
  }
}
