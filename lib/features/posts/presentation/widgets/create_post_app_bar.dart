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
    return AppBar(
      centerTitle: false,
      title: Text(
        isArticle ? 'Create Article' : 'Create Post',
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
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
