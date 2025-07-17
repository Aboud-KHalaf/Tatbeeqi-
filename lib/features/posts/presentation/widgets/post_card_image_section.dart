import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PostImageSection extends StatelessWidget {
  final String imageUrl;

  const PostImageSection({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Center(
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: colorScheme.errorContainer.withValues(alpha: 0.5),
                child: Icon(Icons.broken_image_outlined,
                    color: colorScheme.onErrorContainer),
              ),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
