import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/lecture_model.dart';
import '../models/lesson_model.dart';

abstract class CoursesContentRemoteDataSource {
  Future<List<LectureModel>> fetchLecturesByCourseId(int courseId);
  Future<List<LessonModel>> fetchLessonsByLectureId(int lectureId);
  Future<void> markLessonAsCompleted(int lessonId);
}

class CoursesContentRemoteDataSourceImpl
    implements CoursesContentRemoteDataSource {
  final SupabaseClient supabaseClient;

  CoursesContentRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<LectureModel>> fetchLecturesByCourseId(int courseId) async {
    try {
      final response = await supabaseClient
          .from('lectures')
          .select()
          .eq('course_id', courseId)
          .order('order_index', ascending: true);

      return response.map((lecture) => LectureModel.fromJson(lecture)).toList();
    } catch (e) {
      throw ServerException("Error fetching lectures by course ID: $e");
    }
  }

  @override
  Future<List<LessonModel>> fetchLessonsByLectureId(int lectureId) async {
    try {
      final response = await supabaseClient
          .from('lessons')
          .select('*, lesson_progress(is_completed)')
          .eq('lecture_id', lectureId)
          .order('order_index', ascending: true);

      return response.map<LessonModel>((lesson) {
        final progressList = lesson['lesson_progress'] as List<dynamic>? ?? [];
        final isCompleted =
            progressList.isNotEmpty && progressList[0]['is_completed'] == true;
        return LessonModel.fromJson(lesson, isCompleted: isCompleted);
      }).toList();
    } catch (e) {
      throw ServerException("Error fetching lessons by lecture ID : $e");
    }
  }

  @override
  Future<void> markLessonAsCompleted(int lessonId) async {
    try {
      final userId = supabaseClient.auth.currentUser!.id;
      if (userId.isEmpty) {
        throw ServerException("User ID is empty");
      }
      await supabaseClient.from('lesson_progress').upsert({
        'user_id': userId,
        'lesson_id': lessonId,
        'is_completed': true,
        'completed_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw ServerException("Error marking lesson as completed  : $e");
    }
  }
}
