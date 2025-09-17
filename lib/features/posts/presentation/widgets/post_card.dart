import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_action_buttons.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_categories.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_header.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_image_section.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_text.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

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
    if (post.imageUrl != null && post.imageUrl!.isNotEmpty) {
      context.push(
        AppRoutes.postDetails,
        extra: PostDetailsArgs(post: post, showMore: false),
      );
    }
  }

  void handelLongPress(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: post.text));
    SnackBarHelper.showInfo(
      context: context,
      message: l10n.postCardTextCopied,
    );
  }
}
