import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/views/post_image_full_screen_view.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_action_buttons.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_categories.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_header.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_image_section.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_text_or_article.dart';

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
        onTap: () => handelTap(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PostCardHeader(post: post),
            ),
            const SizedBox(height: 12),
            if (post.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: PostTextOrArticle(post: post),
              ),
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              PostImageSection(imageUrl: post.imageUrl!),
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

  void handelTap(BuildContext context) {
    // TODO add go router navigation
    if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostImageFullScreenView(post: post),
        ),
      );
    }
  }
}
