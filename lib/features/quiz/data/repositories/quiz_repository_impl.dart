import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/error/failures.dart';

import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/user_answer.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_local_data_source.dart';
import '../datasources/quiz_remote_data_source.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;
  final QuizLocalDataSource localDataSource;

  QuizRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<QuizQuestion>>> getQuizQuestions(int lessonId) async {
    try {
      print("Repository: Fetching quiz questions for lesson $lessonId");
      
      // Try to get from remote data source
      final remoteQuestions = await remoteDataSource.fetchQuizQuestions(lessonId);
      
      // Cache the questions locally
      await localDataSource.cacheQuizQuestions(lessonId, remoteQuestions);
      
      // Convert models to entities
      final questions = remoteQuestions
          .map((model) => QuizQuestion(
                id: model.id,
                lessonId: model.lessonId,
                questionText: model.questionText,
                questionType: model.questionType,
                orderIndex: model.orderIndex,
                answers: model.answers,
              ))
          .toList();
      
      return Right(questions);
    } on ServerException catch (e) {
      print("Repository: Server error - ${e.message}");
      return Left(ServerFailure(e.message));
    } catch (e) {
      print("Repository: Unexpected error - $e");
      return Left(ServerFailure('Failed to fetch quiz questions: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, bool>>> evaluateQuizAnswers(
      int lessonId, List<UserAnswer> userAnswers) async {
    try {
      print("Repository: Evaluating quiz answers for lesson $lessonId");
      
      // Get cached questions from local data source
      final cachedQuestions = await localDataSource.getCachedQuizQuestions(lessonId);
      
      if (cachedQuestions.isEmpty) {
        return Left(CacheFailure('No cached questions found for lesson $lessonId'));
      }

      final results = <String, bool>{};

      for (final userAnswer in userAnswers) {
        try {
          final question = cachedQuestions.firstWhere(
            (q) => q.id == userAnswer.questionId,
          );

          final correctAnswer = question.answers.firstWhere(
            (a) => a.isCorrect,
          );

          results[userAnswer.questionId] =
              userAnswer.selectedAnswerId == correctAnswer.id;
        } catch (e) {
          print("Repository: Error evaluating answer for question ${userAnswer.questionId}: $e");
          results[userAnswer.questionId] = false;
        }
      }

      return Right(results);
    } on CacheException catch (e) {
      print("Repository: Cache error - ${e.message}");
      return Left(CacheFailure(e.message));
    } catch (e) {
      print("Repository: Error evaluating quiz answers - $e");
      return Left(ServerFailure('Failed to evaluate quiz answers: $e'));
    }
  }
}
