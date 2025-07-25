import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/core/utils/custom_snack_bar.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/views/post_details_view.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_action_buttons.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_categories.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_header.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_image_section.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_text.dart';

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
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onLongPress: () => handelLongPress(context),
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
                child: PostText(post: post),
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
          builder: (context) => PostDetailsView(post: post, showMore: false),
        ),
      );
    }
  }

  void handelLongPress(BuildContext context) {
    Clipboard.setData(ClipboardData(text: post.text));
    CustomSnackBar.showInfo(
      context: context,
      message: 'Text copied to clipboard',
    );
  }
}
