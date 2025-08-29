import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class CreatePostTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isArticle;

  const CreatePostTextField({
    super.key,
    required this.controller,
    required this.isArticle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.edit_outlined,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              isArticle
                  ? l10n.createPostTextFieldArticleContent
                  : l10n.createPostPlaceholder,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          maxLines: isArticle ? 15 : 8,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.5,
          ),
          decoration: InputDecoration(
            hintText: isArticle
                ? l10n.createPostTextFieldArticleHint
                : l10n.createPostTextFieldPostHint,
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.error,
              ),
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerLowest,
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value?.trim().isEmpty ?? true) {
              return l10n.createPostValidationEnterContent;
            }
            return null;
          },
        ),
      ],
    );
  }
}
