import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/notifications/presentation/widgets/reminder_dialog.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Course course;
  const CustomAppBar({
    super.key,
    required TabController tabController,
    required this.course,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return AppBar(
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
          },
          tooltip: l10n.coursesContentBackTooltip,
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      title: Hero(
        tag: course.courseName,
        child: Text(
          course.courseName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.schedule,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              showDialog(
                context: context,
                builder: (context) => ReminderDialog(
                  courseId: course.id.toString(),
                  courseName: course.courseName,
                ),
              );
            },
            tooltip: l10n.coursesContentScheduleReminders,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: colorScheme.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            labelStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return colorScheme.primary.withValues(alpha: 0.1);
                }
                if (states.contains(WidgetState.hovered)) {
                  return colorScheme.primary.withValues(alpha: 0.05);
                }
                return null;
              },
            ),
            tabs: [
              _buildTab(l10n.coursesContentLectures, Icons.school_outlined),
              _buildTab(l10n.coursesContentTabGrades, Icons.grade_outlined),
             // _buildTab(l10n.coursesContentTabForum, Icons.forum_outlined),
              _buildTab(l10n.coursesContentTabNotes, Icons.note_outlined),
              _buildTab(l10n.coursesContentTabReferences, Icons.library_books_outlined),
              _buildTab(l10n.coursesContentTabAboutCourse, Icons.info_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text, IconData icon) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}
