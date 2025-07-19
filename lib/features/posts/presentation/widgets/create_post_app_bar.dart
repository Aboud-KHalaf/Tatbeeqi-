import 'package:flutter/material.dart';

class CreatePostAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isArticle;
  final bool hasUnsavedChanges;
  final bool canPreview;
  final VoidCallback onClose;
  final VoidCallback onPreview;

  const CreatePostAppBar({
    super.key,
    required this.isArticle,
    required this.hasUnsavedChanges,
    required this.canPreview,
    required this.onClose,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArticle ? 'Create Article' : 'Create Post',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (hasUnsavedChanges)
            Text(
              'Unsaved changes',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onClose,
      ),
      actions: [
        FilledButton.tonalIcon(
          onPressed: canPreview ? onPreview : null,
          icon: const Icon(Icons.visibility_outlined, size: 18),
          label: const Text('Preview'),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}