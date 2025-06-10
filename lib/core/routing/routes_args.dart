import 'package:tatbeeqi/features/news/domain/entities/news_item_entity.dart';

class NewsDetailsArgs {
  final NewsItemEntity newsItem;
  final String heroTag;

  NewsDetailsArgs({
    required this.newsItem,
    required this.heroTag,
  });
}
