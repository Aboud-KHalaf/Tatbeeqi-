import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/core/helpers/Lesson_helper.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';

class CourseContentCard extends StatefulWidget {
  final Lesson lessonItem;
  final VoidCallback onTap;

  const CourseContentCard({
    super.key,
    required this.lessonItem,
    required this.onTap,
  });

  @override
  State<CourseContentCard> createState() => _CourseContentCardState();
}

class _CourseContentCardState extends State<CourseContentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 4.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
    HapticFeedback.selectionClick();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            elevation: _elevationAnimation.value,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: widget.lessonItem.isCompleted
                ? Colors.green.shade50
                : colorScheme.surface,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.lessonItem.isCompleted
                        ? Colors.green.shade300
                        : colorScheme.outline.withValues(alpha: 0.1),
                    width: widget.lessonItem.isCompleted ? 2 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // أيقونة المحتوى مع تحسينات بصرية
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: widget.lessonItem.isCompleted
                              ? Colors.green.shade500
                              : colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                          boxShadow: widget.lessonItem.isCompleted
                              ? [
                                  BoxShadow(
                                    color: Colors.green.shade200
                                        .withValues(alpha: 0.6),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: widget.lessonItem.isCompleted
                                ? Icon(
                                    Icons.check_circle,
                                    key: const ValueKey('completed'),
                                    color: colorScheme.onPrimary,
                                    size: 24,
                                  )
                                : Icon(
                                    LessonHelper.getIcon(
                                        widget.lessonItem.lessonType),
                                    key: const ValueKey('not_completed'),
                                    color: LessonHelper.getIconColor(
                                        widget.lessonItem.lessonType,
                                        colorScheme),
                                    size: 24,
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // العنوان والنوع والمدة
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.lessonItem.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: widget.lessonItem.isCompleted
                                    ? Colors.green.shade700
                                    : colorScheme.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: LessonHelper.getTypeColor(
                                            widget.lessonItem.lessonType,
                                            colorScheme)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: LessonHelper.getTypeColor(
                                              widget.lessonItem.lessonType,
                                              colorScheme)
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    LessonHelper.getTypeText(
                                        widget.lessonItem.lessonType, context),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: LessonHelper.getTypeColor(
                                          widget.lessonItem.lessonType,
                                          colorScheme),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 12,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${widget.lessonItem.durationMinutes} دقيقة',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // زر التحميل مع تحسينات بصرية
                      if (widget.lessonItem.isDownloadable)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: IconButton(
                            icon: Icon(
                              Icons.download_outlined,
                              color: colorScheme.primary,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              SnackBarHelper.showInfo(
                                  context: context, message: "soon");
                            },
                            tooltip: 'تحميل',
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.primaryContainer
                                  .withValues(alpha: 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
