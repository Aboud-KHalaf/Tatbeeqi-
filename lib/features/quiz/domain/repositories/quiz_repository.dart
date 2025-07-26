import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';

import '../entities/quiz_question.dart';
import '../entities/user_answer.dart';

abstract class QuizRepository {
   Future<Either<Failure, List<QuizQuestion>>> getQuizQuestions(int lessonId);
  Future<Either<Failure, Map<String, bool>>> evaluateQuizAnswers(int lessonId, List<UserAnswer> userAnswers);
}
