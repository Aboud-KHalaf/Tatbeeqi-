import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LectureItem extends StatefulWidget {
  final int moduleNumber;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback? onTap;

  const LectureItem({
    super.key,
    required this.moduleNumber,
    required this.isActive,
    required this.isCompleted,
    this.onTap,
  });

  @override
  State<LectureItem> createState() => _LectureItemState();
}

class _LectureItemState extends State<LectureItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    // Define colors based on state
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    Color iconColor;

    if (widget.isCompleted) {
      backgroundColor = Colors.green.shade50;
      borderColor = Colors.green.shade400;
      textColor = Colors.green.shade700;
      iconColor = Colors.green.shade600;
    } else if (widget.isActive) {
      backgroundColor = colorScheme.primaryContainer.withValues(alpha: 0.3);
      borderColor = colorScheme.primary;
      textColor = colorScheme.primary;
      iconColor = colorScheme.primary;
    } else {
      backgroundColor = colorScheme.surface;
      borderColor = colorScheme.outline.withValues(alpha: 0.3);
      textColor = colorScheme.onSurfaceVariant;
      iconColor = colorScheme.onSurfaceVariant;
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              _animationController.forward();
              HapticFeedback.lightImpact();
            },
            onTapUp: (_) {
              _animationController.reverse();
              widget.onTap?.call();
            },
            onTapCancel: () {
              _animationController.reverse();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor,
                  width: widget.isActive || widget.isCompleted ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon based on state
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: widget.isCompleted
                        ? Icon(
                            Icons.check_circle,
                            key: const ValueKey('completed'),
                            color: iconColor,
                            size: 24,
                          )
                        : widget.isActive
                            ? Icon(
                                Icons.play_circle_filled,
                                key: const ValueKey('active'),
                                color: iconColor,
                                size: 24,
                              )
                            : Icon(
                                Icons.radio_button_unchecked,
                                key: const ValueKey('inactive'),
                                color: iconColor,
                                size: 20,
                              ),
                  ),
                  const SizedBox(height: 4),
                  // Module number
                  Text(
                    '${widget.moduleNumber}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  // Status text
                  Text(
                    widget.isCompleted
                        ? 'مكتمل'
                        : widget.isActive
                            ? 'الحالي'
                            : '',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: textColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
