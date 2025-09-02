import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/di/service_locator.dart';
import 'package:tatbeeqi/core/helpers/lesson_helper.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/recent_lessons/recent_lessons_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/recent_lessons/recent_lessons_state.dart';

class RecentlyAddedSection extends StatelessWidget {
  const RecentlyAddedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocProvider(
      create: (_) => sl<RecentLessonsCubit>()..fetch(limit: 4),
      child: BlocBuilder<RecentLessonsCubit, RecentLessonsState>(
        builder: (context, state) {
          if (state is RecentLessonsLoading) {
            return _buildShimmer(colorScheme);
          }
          if (state is RecentLessonsError) {
            return _buildError(colorScheme, textTheme, state.message);
          }
          if (state is RecentLessonsEmpty) {
            return const SizedBox.shrink();
          }
          if (state is RecentLessonsLoaded) {
            final lessons = state.lessons.take(3).toList();
            return Column(
              children: lessons
                  .map((lesson) => _buildRecentLessonItem(
                        context,
                        lesson,
                        colorScheme,
                        textTheme,
                      ))
                  .toList(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildRecentLessonItem(
    BuildContext context,
    Lesson lesson,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final icon = LessonHelper.getIcon(lesson.lessonType);
    final typeText = LessonHelper.getTypeText(lesson.lessonType, context);
    final typeColor = LessonHelper.getTypeColor(lesson.lessonType, colorScheme);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: typeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (lesson.createdBy != null ||
                        lesson.durationMinutes > 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        _buildSubtitle(lesson),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  typeText,
                  style: textTheme.labelSmall?.copyWith(
                    color: typeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(ColorScheme colorScheme) {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: colorScheme.outline.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 10,
                      width: 160,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 48,
                height: 22,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildError(
      ColorScheme colorScheme, TextTheme textTheme, String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.error.withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline,
              color: colorScheme.onErrorContainer, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'حدث خطأ: $message',
              style: textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onErrorContainer),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _buildSubtitle(Lesson lesson) {
    final parts = <String>[];
    if (lesson.createdBy != null && lesson.createdBy!.trim().isNotEmpty) {
      parts.add(lesson.createdBy!.trim());
    }
    if (lesson.durationMinutes > 0) {
      parts.add('${lesson.durationMinutes} دقيقة');
    }
    return parts.join(' • ');
  }
}
