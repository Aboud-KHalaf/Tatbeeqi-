import '../entities/quiz_question.dart';
import '../entities/user_answer.dart';

abstract class QuizRepository {
  Future<List<QuizQuestion>> getQuizQuestions(String lessonId);
  Future<Map<String, bool>> evaluateQuizAnswers(List<UserAnswer> userAnswers);
}
