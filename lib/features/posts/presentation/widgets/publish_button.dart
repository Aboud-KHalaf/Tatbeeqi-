
import 'package:flutter/material.dart';

class PublishButton extends StatelessWidget {
  final bool isArticle;
  final bool canSubmit;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const PublishButton({
    super.key,
    required this.isArticle,
    required this.canSubmit,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: canSubmit ? onSubmit : null,
        icon: isSubmitting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    colorScheme.onPrimary,
                  ),
                ),
              )
            : Icon(
                isArticle ? Icons.publish : Icons.send,
                size: 20,
              ),
        label: Text(
          isSubmitting
              ? (isArticle ? 'Publishing...' : 'Posting...')
              : (isArticle ? 'Publish Article' : 'Post'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: canSubmit
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          foregroundColor:
              canSubmit ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
          elevation: canSubmit ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}