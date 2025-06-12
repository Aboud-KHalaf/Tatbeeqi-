import 'package:tatbeeqi/features/news/domain/entities/news_item_entity.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';

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
