import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/di/service_locator.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/reminders_cubit.dart';
import 'package:tatbeeqi/features/notifications/presentation/views/my_reminders_view.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/my_posts/my_posts_cubit.dart';
import 'package:tatbeeqi/features/posts/presentation/views/my_posts_view.dart';
import 'package:tatbeeqi/features/reports/presentation/views/my_reports_view.dart';
import 'package:tatbeeqi/features/feedbacks/presentation/views/my_feedbacks_view.dart';
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => sl<MyPostsCubit>(),
                            child: const MyPostsView(),
                          ),
                        ),
                      );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyReportsView(),
                        ),
                      );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => sl<MyPostsCubit>(),
                            child: const MyPostsView(),
                          ),
                        ),
                      );
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                    create: (context) => sl<RemindersCubit>(),
                                    child: const MyRemindersView(),
                                  )));
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyFeedbacksView(),
                        ),
                      );
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
