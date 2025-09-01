import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../models/lecture_model.dart';
import '../models/lesson_model.dart';

abstract class CoursesContentRemoteDataSource {
  Future<List<LectureModel>> fetchLecturesByCourseId(int courseId);
  Future<List<LessonModel>> fetchLessonsByLectureId(int lectureId);
  Future<List<LessonModel>> fetchRecentLessons({int limit = 4});
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
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException('User not logged in');
      }

      final response = await supabaseClient
          .from('lessons')
          // left join lesson_progress and profiles (creator)p to fetch completion and creator name
          .select('*, lesson_progress!left(user_id, is_completed), profiles!fk_created_by(name)')
          .eq('lecture_id', lectureId)
          // keep left join; do not filter on joined table to avoid turning into inner join
          .order('order_index', ascending: true);

      return (response as List).map<LessonModel>((lesson) {
        final progressList = lesson['lesson_progress'] as List<dynamic>? ?? [];
        final isCompleted = progressList.any((p) =>
            p is Map && p['user_id'] == userId && p['is_completed'] == true);

        // Map creator profile name into created_by so the model can consume it as a String
        final Map<String, dynamic> lessonMap = Map<String, dynamic>.from(lesson as Map);
        final creatorName = (lesson['profiles'] is Map) ? lesson['profiles']['name'] as String? : null;
        if (creatorName != null) {
          lessonMap['created_by'] = creatorName;
        }

        return LessonModel.fromJson(lessonMap, isCompleted: isCompleted);
      }).toList();
    } catch (e) {
      throw ServerException("Error fetching lessons by lecture ID : $e");
    }
  }

  @override
  Future<List<LessonModel>> fetchRecentLessons({int limit = 4}) async {
    try {
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException('User not logged in');
      }

      final response = await supabaseClient
          .from('lessons')
          .select('*, lesson_progress!left(user_id, is_completed), profiles!fk_created_by(name)')
          .order('published_at', ascending: false, nullsFirst: false)
          .order('updated_at', ascending: false, nullsFirst: false)
          .limit(limit);

      return (response as List).map<LessonModel>((lesson) {
        final progressList = lesson['lesson_progress'] as List<dynamic>? ?? [];
        final isCompleted = progressList.any((p) =>
            p is Map && p['user_id'] == userId && p['is_completed'] == true);

        final Map<String, dynamic> lessonMap = Map<String, dynamic>.from(lesson as Map);
        final creatorName = (lesson['profiles'] is Map) ? lesson['profiles']['name'] as String? : null;
        if (creatorName != null) {
          lessonMap['created_by'] = creatorName;
        }

        return LessonModel.fromJson(lessonMap, isCompleted: isCompleted);
      }).toList();
    } catch (e) {
      throw ServerException("Error fetching recent lessons : $e");
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

