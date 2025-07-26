import 'package:tatbeeqi/core/error/exceptions.dart';

import '../models/quiz_question_model.dart';

abstract class QuizLocalDataSource {
  Future<List<QuizQuestionModel>> getCachedQuizQuestions(int lessonId);
  Future<void> cacheQuizQuestions(
      int lessonId, List<QuizQuestionModel> questions);
}

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  final Map<int, List<QuizQuestionModel>> _cache = {};

  @override
  Future<List<QuizQuestionModel>> getCachedQuizQuestions(int lessonId) async {
    try {
      print("hello from local , i am getting quiz questions");
      return _cache[lessonId] ?? [];
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheQuizQuestions(
      int lessonId, List<QuizQuestionModel> questions) async {
    print("hello from local , i am caching quiz questions");
    try {
      _cache[lessonId] = questions;
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
