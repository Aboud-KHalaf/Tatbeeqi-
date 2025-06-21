import 'package:tatbeeqi/features/news/domain/entities/news_item_entity.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';
import 'package:tatbeeqi/features/quiz/domain/entities/quiz_question.dart';

class NewsDetailsArgs {
  final NewsItemEntity newsItem;
  final String heroTag;

  NewsDetailsArgs({
    required this.newsItem,
    required this.heroTag,
  });
}

class AddUpdateNoteArgs {
  final Note? note;
  final String courseId;

  AddUpdateNoteArgs({this.note, required this.courseId});
}

class QuizResultArgs {
   final int score;
  final Map<String, bool> results;
  final List<QuizQuestion> questions;
  final Map<String, String> userAnswers;

  QuizResultArgs({required this.score, required this.results, required this.questions, required this.userAnswers});
}
