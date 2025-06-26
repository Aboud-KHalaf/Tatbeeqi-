import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tatbeeqi/features/posts/presentation/widgets/comments_sheet.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme),
            const SizedBox(height: 16.0),
            MarkdownBody(data: post.text),
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(post.imageUrl!),
                ),
              ),
            const SizedBox(height: 16.0),
            _buildCategories(theme),
            const Divider(height: 32.0),
            _buildActionButtons(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          // Placeholder for author's avatar
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${post.authorId}'),
          radius: 24,
        ),
        const SizedBox(width: 12.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.authorName, style: theme.textTheme.titleMedium),
            Text(
              timeago.format(post.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategories(ThemeData theme) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: post.categories
          .map((category) => Chip(
                label: Text(category),
                backgroundColor: theme.colorScheme.secondaryContainer,
                labelStyle: theme.textTheme.bodySmall,
              ))
          .toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
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
