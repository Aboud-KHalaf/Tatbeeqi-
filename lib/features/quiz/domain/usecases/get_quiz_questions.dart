import '../entities/quiz_question.dart';
import '../repositories/quiz_repository.dart';

class GetQuizQuestionsUseCase {
  final QuizRepository repository;

  GetQuizQuestionsUseCase(this.repository);

  Future<List<QuizQuestion>> call(String lessonId) {
    return repository.getQuizQuestions(lessonId);
  }
}
