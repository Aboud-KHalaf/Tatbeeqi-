import '../entities/user_answer.dart';
import '../repositories/quiz_repository.dart';

class EvaluateQuizAnswersUseCase {
  final QuizRepository repository;

  EvaluateQuizAnswersUseCase(this.repository);

  Future<Map<String, bool>> call(List<UserAnswer> userAnswers) {
    return repository.evaluateQuizAnswers(userAnswers);
  }
}
