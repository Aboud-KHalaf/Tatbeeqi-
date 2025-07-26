import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import '../entities/user_answer.dart';
import '../repositories/quiz_repository.dart';

class EvaluateQuizAnswersUseCase {
  final QuizRepository repository;

  EvaluateQuizAnswersUseCase(this.repository);

  Future<Either<Failure, Map<String, bool>>> call(EvaluateQuizAnswersParams params) {
    return repository.evaluateQuizAnswers(params.lessonId, params.userAnswers);
  }
}

class EvaluateQuizAnswersParams {
  final int lessonId;
  final List<UserAnswer> userAnswers;

  EvaluateQuizAnswersParams({required this.lessonId, required this.userAnswers});
}
