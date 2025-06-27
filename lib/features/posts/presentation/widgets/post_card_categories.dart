import 'package:flutter/material.dart';

class PostCardCategories extends StatelessWidget {
  final List<String> categories;
  const PostCardCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);  
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: categories
          .map((category) => Chip(
                label: Text(category),
                backgroundColor: theme.colorScheme.secondaryContainer,
                labelStyle: theme.textTheme.bodySmall,
              ))
          .toList(),
    );
  }
}
