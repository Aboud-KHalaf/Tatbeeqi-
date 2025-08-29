import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
              ? (isArticle
                  ? l10n.publishButtonPublishingArticle
                  : l10n.publishButtonPosting)
              : (isArticle
                  ? l10n.publishButtonPublishArticle
                  : l10n.publishButtonPost),
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