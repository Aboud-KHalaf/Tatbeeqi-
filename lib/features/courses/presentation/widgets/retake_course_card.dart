import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';

class RetakeCourseCard extends StatefulWidget {
  final Course course;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const RetakeCourseCard({
    super.key,
    required this.course,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  State<RetakeCourseCard> createState() => _RetakeCourseCardState();
}

class _RetakeCourseCardState extends State<RetakeCourseCard>
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
      begin: 0.0,
      end: 2.0,
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

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: () {
              HapticFeedback.selectionClick();
              widget.onChanged(!widget.isSelected);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isSelected
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.2),
                  width: widget.isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.04),
                    blurRadius: 4 + _elevationAnimation.value,
                    offset: Offset(0, 2 + _elevationAnimation.value),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Custom animated checkbox
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? colorScheme.primary
                            : Colors.transparent,
                        border: Border.all(
                          color: widget.isSelected
                              ? colorScheme.primary
                              : colorScheme.outline,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: widget.isSelected
                          ? Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: colorScheme.onPrimary,
                            )
                          : null,
                    ),

                    const SizedBox(width: 16),

                    // Course content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.course.courseName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: widget.isSelected
                                  ? colorScheme.onSurface
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
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondaryContainer
                                      .withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'السنة: ${widget.course.studyYear}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.tertiaryContainer
                                      .withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'الفصل: ${widget.course.semester}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onTertiaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
