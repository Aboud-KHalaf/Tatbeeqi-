import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class QuizNavigationButtons extends StatelessWidget {
  final bool canGoBack;
  final bool canGoNext;
  final bool isLastQuestion;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onSubmit;

  const QuizNavigationButtons({
    Key? key,
    required this.canGoBack,
    required this.canGoNext,
    required this.isLastQuestion,
    this.onPrevious,
    this.onNext,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Previous Button
            if (canGoBack)
              Expanded(
                child: _NavigationButton(
                  onPressed: onPrevious,
                  icon: Icons.arrow_back_rounded,
                  label: l10n.quizPrev,
                  isPrimary: false,
                  colorScheme: colorScheme,
                  theme: theme,
                ),
              )
            else
              const Expanded(child: SizedBox.shrink()),
            const SizedBox(width: 16),
            // Next/Submit Button
            Expanded(
              flex: isLastQuestion ? 2 : 1,
              child: _NavigationButton(
                onPressed: isLastQuestion
                    ? (canGoNext ? onSubmit : null)
                    : (canGoNext ? onNext : null),
                icon: isLastQuestion
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_rounded,
                label: isLastQuestion ? l10n.quizSubmit : l10n.quizNext,
                isPrimary: true,
                isEnabled: canGoNext,
                colorScheme: colorScheme,
                theme: theme,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;
  final bool isEnabled;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _NavigationButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.isPrimary,
    this.isEnabled = true,
    required this.colorScheme,
    required this.theme,
  });

  @override
  State<_NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<_NavigationButton>
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

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && widget.isEnabled;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 56,
              decoration: BoxDecoration(
                color: isEnabled
                    ? (widget.isPrimary
                        ? widget.colorScheme.primary
                        : widget.colorScheme.surfaceContainerHigh)
                    : widget.colorScheme.surfaceContainerHigh
                        .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: widget.isPrimary
                    ? null
                    : Border.all(
                        color: isEnabled
                            ? widget.colorScheme.outline.withValues(alpha: 0.5)
                            : widget.colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                boxShadow: isEnabled && widget.isPrimary
                    ? [
                        BoxShadow(
                          color:
                              widget.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: isEnabled
                        ? (widget.isPrimary
                            ? widget.colorScheme.onPrimary
                            : widget.colorScheme.onSurface)
                        : widget.colorScheme.onSurface.withValues(alpha: 0.38),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: widget.theme.textTheme.titleSmall?.copyWith(
                      color: isEnabled
                          ? (widget.isPrimary
                              ? widget.colorScheme.onPrimary
                              : widget.colorScheme.onSurface)
                          : widget.colorScheme.onSurface
                              .withValues(alpha: 0.38),
                      fontWeight: FontWeight.w600,
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
