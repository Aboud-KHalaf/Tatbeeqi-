import 'package:flutter/material.dart';

class PostCardCategories extends StatelessWidget {
  final List<String> categories;
  const PostCardCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (categories.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: categories
          .map((category) => Chip(
                label: Text(category),
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: Colors.transparent),
                ),
                // TODO: Add onTap to handle category tap
              ))
          .toList(),
    );
  }
}
