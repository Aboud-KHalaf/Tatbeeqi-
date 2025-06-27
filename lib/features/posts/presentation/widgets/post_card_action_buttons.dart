import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/comments_sheet.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';

class PostCardActionButtons extends StatelessWidget {
  final Post post;
  const PostCardActionButtons({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _actionButton(context, Icons.thumb_up_outlined, 'Like', () {}),
        _actionButton(context, Icons.comment_outlined, 'Comment', () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => CommentsSheet(postId: post.id),
          );
        }),
        _actionButton(context, Icons.share_outlined, 'Share', () {
          Share.share('Check out this post: ${post.text}');
        }),
      ],
    );
  }

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.grey[700]),
      label: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
    );
  }
}
