import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import '../models/quiz_question_model.dart';

abstract class QuizRemoteDataSource {
  Future<List<QuizQuestionModel>> fetchQuizQuestions(int lessonId);
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final SupabaseClient client;

  QuizRemoteDataSourceImpl(this.client);

  @override
  Future<List<QuizQuestionModel>> fetchQuizQuestions(int lessonId) async {
    print("hello from remote , i am fetching quiz questions");
    try {
      final response = await client
          .from('quiz_questions')
          .select(
              'id, lesson_id, question_text, question_type, order_index, quiz_answers(id, answer_text, is_correct)')
          .eq('lesson_id', lessonId)
          .order('order_index', ascending: true);

      if (response.isEmpty) return [];

      return response.map<QuizQuestionModel>((q) {
        return QuizQuestionModel.fromJson({
          'id': q['id'].toString(),
          'lessonId': q['lesson_id'].toString(),
          'questionText': q['question_text'],
          'questionType': q['question_type'],
          'orderIndex': q['order_index'],
          'answers': q['quiz_answers'] ?? [],
        });
      }).toList();
    } on PostgrestException catch (e) {
      print("error ${e.toString()}");
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print("error 2 ${e.toString()}");
      throw ServerException('Unexpected error: $e');
    }
  }
}
