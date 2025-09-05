import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class RetakeCoursesTitle extends StatelessWidget {
  const RetakeCoursesTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.retakeCoursesTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
            letterSpacing: -0.25,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.retakeCoursesSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}