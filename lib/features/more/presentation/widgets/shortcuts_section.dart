import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/features/feedbacks/presentation/widgets/feedback_wrapper.dart';
 import 'package:tatbeeqi/l10n/app_localizations.dart';

class ShortcutsSection extends StatelessWidget {
  const ShortcutsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.shortcuts,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ShortcutCard(
                    icon: Icons.bookmark_rounded,
                    title: l10n.savedPosts,
                    backgroundColor: colorScheme.primaryContainer,
                    iconColor: colorScheme.onPrimaryContainer,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.push(AppRoutes.myPosts);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ShortcutCard(
                    icon: Icons.assessment_rounded,
                    title: l10n.myReports,
                    backgroundColor: colorScheme.secondaryContainer,
                    iconColor: colorScheme.onSecondaryContainer,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.push(AppRoutes.myReports);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ShortcutCard(
                    icon: Icons.article_rounded,
                    title: l10n.myPosts,
                    backgroundColor: colorScheme.tertiaryContainer,
                    iconColor: colorScheme.onTertiaryContainer,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.push(AppRoutes.myPosts);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ShortcutCard(
                    icon: Icons.alarm_rounded,
                    title: l10n.myReminders,
                    backgroundColor: colorScheme.errorContainer,
                    iconColor: colorScheme.onErrorContainer,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.push(AppRoutes.myReminders);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ShortcutCard(
                    icon: Icons.feedback_rounded,
                    title: 'ملاحظاتي',
                    backgroundColor: colorScheme.primaryContainer,
                    iconColor: colorScheme.onPrimaryContainer,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context.push(AppRoutes.myFeedbacks);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ShortcutCard(
                    icon: Icons.add_comment_rounded,
                    title: 'إضافة ملاحظة',
                    backgroundColor: colorScheme.secondaryContainer,
                    iconColor: colorScheme.onSecondaryContainer,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      FeedbackWrapper.showFeedbackDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ShortcutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const ShortcutCard({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
