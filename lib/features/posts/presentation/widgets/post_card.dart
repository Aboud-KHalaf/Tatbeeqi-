import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_header.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_categories.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_action_buttons.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          // TODO: Implement post tap, e.g., navigate to post details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: PostCardHeader(post: post),
            ),
            if (post.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: post.isArticle
                    ? MarkdownBody(
                        softLineBreak: true,
                        data: post.text,
                        styleSheet:
                            MarkdownStyleSheet.fromTheme(theme).copyWith(
                          p: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              color: colorScheme.onSurfaceVariant),
                        ),
                      )
                    : Text(post.text),
              ),
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(
                          0)), // No rounding if it's in the middle
                  child: CachedNetworkImage(
                    imageUrl: post.imageUrl!,
                    placeholder: (context, url) => AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        child: Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onSurfaceVariant)),
                      ),
                    ),
                    errorWidget: (context, url, error) => AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color:
                            colorScheme.errorContainer.withValues(alpha: 0.5),
                        child: Icon(Icons.broken_image_outlined,
                            color: colorScheme.onErrorContainer),
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PostCardCategories(categories: post.categories),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: PostCardActionButtons(post: post),
            ),
          ],
        ),
      ),
    );
  }
}
