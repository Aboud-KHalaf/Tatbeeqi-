import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      centerTitle: false,
      title: Text(
        isArticle ? l10n.createPostAppBarTitleArticle : l10n.createPostAppBarTitlePost,
      ),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onClose,
      ),
      actions: [
        FilledButton.tonalIcon(
          onPressed: canPreview ? onPreview : null,
          icon: const Icon(Icons.visibility_outlined, size: 18),
          label: Text(l10n.createPostPreview),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
