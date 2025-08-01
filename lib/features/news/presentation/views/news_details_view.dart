import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/utils/app_functions.dart';
import 'package:tatbeeqi/core/widgets/custom_markdown_body_widget.dart';
import 'package:tatbeeqi/features/news/domain/entities/news_item_entity.dart';

class NewsDetailsView extends StatelessWidget {
  static const String routeId = '/newsDetailsView';

  final NewsItemEntity newsItem;
  final String heroTag;

  const NewsDetailsView({
    super.key,
    required this.newsItem,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.3,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Directionality(
                textDirection: getTextDirection(newsItem.title),
                child: Text(
                  newsItem.title,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          blurRadius: 2.0,
                          color: Colors.black.withValues(alpha: 0.5))
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              titlePadding:
                  const EdgeInsetsDirectional.only(start: 72, bottom: 16),
              background: Hero(
                tag: heroTag,
                child: Image.network(
                  newsItem.imageUrl,
                  // fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        color: colorScheme.outline,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta Info (Category & Date)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(newsItem.category),
                        backgroundColor:
                            colorScheme.primaryContainer.withValues(alpha: 0.7),
                        labelStyle: textTheme.labelSmall
                            ?.copyWith(color: colorScheme.primary),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      Text(
                        newsItem.date.toString(), // Format as needed
                        style: textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Title (again, for context below app bar)
                  Text(
                    newsItem.title,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Divider(height: 32),
                  // Markdown Body
                  CustomMarkDownBodyWidget(data: newsItem.body),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
