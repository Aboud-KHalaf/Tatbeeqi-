import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import '../entities/quiz_question.dart';
import '../repositories/quiz_repository.dart';

class GetQuizQuestionsUseCase {
  final QuizRepository repository;

  GetQuizQuestionsUseCase(this.repository);

  Future<Either<Failure, List<QuizQuestion>>> call(int lessonId) {
    return repository.getQuizQuestions(lessonId);
  }
}
