import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';

class PostCardHeader extends StatelessWidget {
  final Post post;
  const PostCardHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: 'https://i.pravatar.cc/150?u=${post.authorId}',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: colorScheme.surfaceVariant,
            ),
            errorWidget: (context, url, error) => Container(
              color: colorScheme.surfaceVariant,
              child: Icon(Icons.person, color: colorScheme.onSurfaceVariant),
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                timeago.format(post.createdAt, locale: 'en_short'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: Implement more options
          },
          icon: const Icon(Icons.more_horiz),
          tooltip: 'More options',
        ),
      ],
    );
  }
}
