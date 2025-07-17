import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/comments_sheet.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed/post_feed_event.dart';

class PostCardActionButtons extends StatelessWidget {
  final Post post;
  const PostCardActionButtons({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _actionButton(
              context: context,
              icon: post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
              label: post.likesCount.toString(),
              onPressed: () {
                context.read<PostsBloc>().add(LikePostToggledEvent(post.id));
              },
            ),
            const SizedBox(width: 8),
            _actionButton(
              context: context,
              icon: Icons.mode_comment_outlined,
              label: post.commentsCount.toString(),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => BlocProvider.value(
                    value: context.read<PostsBloc>(),
                    child: CommentsSheet(postId: post.id),
                  ),
                );
              },
            ),
          ],
        ),
        Tooltip(
          message: 'Share',
          child: IconButton(
            icon: Icon(Icons.share_outlined, color: color, size: 22),
            onPressed: () {
              //   SharePlus.instance.share('Check out this post from Tatbeeqi!');
            },
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;

    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: color),
      label: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
