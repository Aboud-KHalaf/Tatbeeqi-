import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';

class StreakNavigationButton extends StatefulWidget {
  final int currentStreak;
  final bool isStreakActive;

  const StreakNavigationButton({
    super.key,
    required this.currentStreak,
    required this.isStreakActive,
  });

  @override
  State<StreakNavigationButton> createState() => _StreakNavigationButtonState();
}

class _StreakNavigationButtonState extends State<StreakNavigationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isStreakActive) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isStreakActive ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              context.push(AppRoutes.streaksPath);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isStreakActive
                      ? [Colors.orange.withOpacity(0.2), Colors.red.withOpacity(0.1)]
                      : [colorScheme.primary.withOpacity(0.1), colorScheme.secondary.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isStreakActive
                      ? Colors.orange.withOpacity(0.3)
                      : colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: widget.isStreakActive ? Colors.orange : colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.currentStreak}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: widget.isStreakActive ? Colors.orange : colorScheme.primary,
                      fontWeight: FontWeight.bold,
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
