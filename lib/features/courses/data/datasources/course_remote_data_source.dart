import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/features/courses/data/models/course_data_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCoursesByStudyYearAndDepartmentId(
      {required int studyYear, required int departmentId});
  Future<List<CourseModel>> getAllCoursesForReatake(
      {required int studyYear, required int departmentId});
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final SupabaseClient supabaseClient;

  CourseRemoteDataSourceImpl({required this.supabaseClient});
  @override
  Future<List<CourseModel>> getCoursesByStudyYearAndDepartmentId({
    required int studyYear,
    required int departmentId,
  }) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException('User not logged in');
      }

      final response =
          await supabaseClient.rpc('get_courses_with_progress', params: {
        'input_study_year': studyYear,
        'input_department_id': departmentId,
        'input_user_id': userId,
      });

      final data = response as List<dynamic>;

      return data.map((json) {
        return CourseModel.fromJson({
          ...json as Map<String, dynamic>,
          'progress_percent': json['progress_percent'], // إضافة نسبة التقدم
        });
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException(
          'Failed to fetch courses with progress: ${e.toString()}');
    }
  }

  @override
  Future<List<CourseModel>> getAllCoursesForReatake(
      {required int studyYear, required int departmentId}) async {
    try {
      final response = await supabaseClient
          .from('courses')
          .select()
          .neq('study_year', studyYear)
          .eq('department_id', departmentId);

      final List<dynamic> data = response as List<dynamic>;
      return data
          .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch courses: ${e.toString()}');
    }
  }
}
