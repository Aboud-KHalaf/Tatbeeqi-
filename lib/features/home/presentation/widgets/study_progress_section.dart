import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/recent_courses_cubit/recent_courses_cubit.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/recent_courses_cubit/recent_courses_state.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/course_card_progress.dart';

class StudyProgressSection extends StatefulWidget {
  const StudyProgressSection({super.key});

  @override
  State<StudyProgressSection> createState() => _StudyProgressSectionState();
}

class _StudyProgressSectionState extends State<StudyProgressSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentCoursesCubit, RecentCoursesState>(
      builder: (context, state) {
        if (state is RecentCoursesLoading) {
          return _buildShimmer();
        }
        if (state is RecentCoursesError) {
          return _buildError(state.message);
        }
        if (state is RecentCoursesEmpty) {
          return _buildEmpty();
        }
        if (state is RecentCoursesLoaded) {
          final courses = state.courses;
          return SizedBox(
            height: 145,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return _buildCourseCard(context, course, index, userId: "123");
              },
            ),
          );
        }
        // Fallback (shouldn't happen)
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCourseCard(
    BuildContext context,
    Course course,
    int index, {
    required String userId,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
        final rawProgress = course.progressPercent ?? 0;
    final progress = rawProgress.clamp(0.0, 1.0); // to avoid over 100%
    final progressText = '${(progress * 100).toInt()}%';
    return Container(
      width: 110,
      margin: const EdgeInsetsDirectional.only(end: 16),
      child: GestureDetector(
        onTap: () {
          context.read<RecentCoursesCubit>().track(userId, course.id);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon container with enhanced styling
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                    child: Icon(
                      Icons.school_rounded,
                      size: 24,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
      
                  const SizedBox(height: 6),
      
                  // Course title with better typography
                  Text(
                    course.courseName,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      height: 1.2,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
      
                  const SizedBox(height: 6),
      
                   CourseCardProgress(progress: progress, progressText: progressText),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) => Container(
          width: 110,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 145,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Center(
        child: Text(
          'ابدأ الدراسة اليوم — لا توجد مواد حديثة',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 145,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.error.withOpacity(0.4)),
      ),
      child: Center(
        child: Text(
          'حدث خطأ: $message',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onErrorContainer,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
