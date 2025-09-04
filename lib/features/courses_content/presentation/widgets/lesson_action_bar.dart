import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lesson_completion/lesson_completion_cubit.dart';

class LessonActionBar extends StatelessWidget {
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onAddNote;
  final VoidCallback onAskAi;
  final Lesson lesson;

  const LessonActionBar({
    super.key,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.onAddNote,
    required this.onAskAi,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
             _buildCompactNavButton(
              context: context,
              icon: Icons.arrow_back,
              onPressed: canGoNext ? onNext : null,
            ),
            const SizedBox(width: 8),
            _buildCompactNavButton(
              context: context,
              icon: Icons.arrow_forward,
              onPressed: canGoPrevious ? onPrevious : null,
            ),
           
            const SizedBox(width: 8),
            _CompletionButton(lesson: lesson),
            const Spacer(),
            _buildFloatingActionButton(
              context: context,
              icon: Icons.note_add,
              onPressed: onAddNote,
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: 8),
            _buildFloatingActionButton(
              context: context,
              icon: Icons.psychology,
              onPressed: onAskAi,
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactNavButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = onPressed != null;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isEnabled
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled
              ? colorScheme.outline.withOpacity(0.2)
              : colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
          color: isEnabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withOpacity(0.38),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildFloatingActionButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 22,
          color: foregroundColor,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class _CompletionButton extends StatelessWidget {
  final Lesson lesson;
  const _CompletionButton({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<LessonCompletionCubit, LessonCompletionState>(
      listenWhen: (prev, curr) =>
          curr is LessonCompletionError || curr is LessonCompletionSuccess,
      listener: (context, state) {
        if (state is LessonCompletionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is LessonCompletionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تعليم الدرس كمكتمل')),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LessonCompletionLoading;
        final isDone = lesson.isCompleted;

        if (isLoading) {
          return Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
            ),
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
            ),
          );
        }

        return Tooltip(
          message: isDone ? 'مكتمل' : 'تعليم كمكتمل',
          child: InkWell(
            onTap: isDone
                ? null
                : () => context
                    .read<LessonCompletionCubit>()
                    .markLessonAsCompleted(lesson.id),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDone
                    ? Colors.green.shade300
                    : colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
              ),
              child: Icon(
                isDone ? Icons.check_circle_rounded : Icons.check_rounded,
                size: 22,
                color: isDone
                    ? colorScheme.onTertiaryContainer
                    : colorScheme.onSurface,
              ),
            ),
          ),
        );
      },
    );
  }
}
