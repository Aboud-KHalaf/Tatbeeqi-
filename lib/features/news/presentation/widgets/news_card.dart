import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';
import 'package:tatbeeqi/features/news/domain/entities/news_item_entity.dart';
import 'package:tatbeeqi/features/news/presentation/widgets/news_card_category_indicator.dart';
import 'package:tatbeeqi/features/news/presentation/widgets/news_card_content.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.item,
    required this.isSmallScreen,
    required this.isCurrentPage,
    required this.colorScheme,
  });

  final NewsItemEntity item;
  final bool isSmallScreen;
  final bool isCurrentPage;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.newsDetails,
          extra: NewsDetailsArgs(newsItem: item, heroTag: 'someTag'),
        );
      },
      child: Hero(
        tag: 'news_${item.id}',
        child: Container(
          height: 200,
          margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 1 : 2),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12.0),
            border:
                Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
          ),
          child: Stack(
            children: [
              NewsCardContent(
                item: item,
                isCurrentPage: isCurrentPage,
                isSmallScreen: isSmallScreen,
              ),
              NewsCardCategoryIndicator(item: item),
            ],
          ),
        ),
      ),
    );
  }
}
