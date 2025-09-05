import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/features/courses_details.dart/data/models/course_details_model.dart';

abstract class CourseDetailsRemoteDataSource {
  Future<CourseDetailsModel> fetchCourseDetails(int courseId);
}

class CourseDetailsRemoteDataSourceImpl implements CourseDetailsRemoteDataSource {
  final SupabaseClient supabaseClient;

  CourseDetailsRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<CourseDetailsModel> fetchCourseDetails(int courseId) async {
    try {
      final response = await supabaseClient
          .from('course_details')
          .select()
          .eq('course_id', courseId)
          .single();

      return CourseDetailsModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch course details: $e');
    }
  }
}
