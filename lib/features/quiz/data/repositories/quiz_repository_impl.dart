import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/user_answer.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_local_data_source.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizLocalDataSource localDataSource;

  QuizRepositoryImpl(this.localDataSource);

  @override
  Future<List<QuizQuestion>> getQuizQuestions(String lessonId) async {
    final questionModels = await localDataSource.getQuizQuestions(lessonId);
    return questionModels;
  }

  @override
  Future<Map<String, bool>> evaluateQuizAnswers(List<UserAnswer> userAnswers) async {
    // In a real app, this might involve a remote server call.
    // Here, we'll simulate the logic locally.
    final results = <String, bool>{};
    final allQuestions = await getQuizQuestions('l1'); // Assuming a fixed lessonId for now

    for (final userAnswer in userAnswers) {
      final question = allQuestions.firstWhere((q) => q.id == userAnswer.questionId);
      final correctAnswer = question.answers.firstWhere((a) => a.isCorrect);
      results[userAnswer.questionId] = userAnswer.selectedAnswerId == correctAnswer.id;
    }

    return results;
  }
}
