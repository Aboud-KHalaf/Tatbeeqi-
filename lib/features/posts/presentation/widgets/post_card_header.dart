import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';

class PostCardHeader extends StatelessWidget {
  final Post post;
  const PostCardHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
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
}
