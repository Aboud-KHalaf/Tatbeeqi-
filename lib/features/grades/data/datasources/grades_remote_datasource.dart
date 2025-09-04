import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/features/grades/data/models/grade_model.dart';

abstract class GradesRemoteDataSource {
  Future<void> insertGrade(GradeModel grade);
  Future<void> updateGrade(GradeModel grade);
  Future<List<GradeModel>> fetchGradesByLessonAndCourseId(
      String lessonId, String courseId);
  Future<List<GradeModel>> fetchGradesByCourseId(String courseId);
}

class GradesRemoteDataSourceImpl implements GradesRemoteDataSource {
  final SupabaseClient client;

  GradesRemoteDataSourceImpl(this.client);

  @override
  Future<void> insertGrade(GradeModel grade) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw ServerException('User not authenticated');
      }
      final gradeWithUser = grade.copyWith(studentId: userId);
      await client.from('grades').insert(gradeWithUser.toJson());
    } on PostgrestException catch (e) {
      print(e.message);
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print(e.toString());
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> updateGrade(GradeModel grade) async {
    try {
      await client.from('grades').update(grade.toJson()).eq('id', grade.id);
    } on PostgrestException catch (e) {
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<GradeModel>> fetchGradesByLessonAndCourseId(
      String lessonId, String courseId) async {
    try {
      final response = await client
          .from('grades')
          .select(
              'id, lesson_id, quiz_id, lecture_id, course_id, student_id, score, submission_date, lessons(title)')
          .eq('lesson_id', lessonId)
          .eq('course_id', courseId)
          .order('submission_date', ascending: false);
      return (response as List)
          .map((e) => GradeModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<GradeModel>> fetchGradesByCourseId(String courseId) async {
    try {
      final studentId = client.auth.currentUser?.id;
      if (studentId == null) {
        throw ServerException('User not authenticated');
      }
      final response = await client
          .from('grades')
          .select(
              'id, lesson_id, quiz_id, lecture_id, course_id, student_id, score, submission_date, lessons(title)')
          .eq('course_id', courseId)
          .eq('student_id', studentId)
          .order('submission_date', ascending: false);
      return (response as List)
          .map((e) => GradeModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on PostgrestException catch (e) {
      print(e.message);

      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print(e.toString());
      throw ServerException('Unexpected error: $e');
    }
  }
}
