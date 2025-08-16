import 'package:flutter/material.dart';

class CompactNavigationButtons extends StatelessWidget {
  final bool canGoBack;
  final bool canGoNext;
  final bool isLastQuestion;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onSubmit;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const CompactNavigationButtons({
    Key? key,
    required this.canGoBack,
    required this.canGoNext,
    required this.isLastQuestion,
    this.onPrevious,
    this.onNext,
    this.onSubmit,
    required this.colorScheme,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Previous Button - Compact
        if (canGoBack)
          Expanded(
            child: _CompactButton(
              onPressed: onPrevious,
              icon: Icons.arrow_back_rounded,
              label: 'Previous',
              isPrimary: false,
              colorScheme: colorScheme,
              theme: theme,
            ),
          )
        else
          const Expanded(child: SizedBox.shrink()),
        const SizedBox(width: 12),
        // Next/Submit Button - Compact
        Expanded(
          flex: isLastQuestion ? 2 : 1,
          child: _CompactButton(
            onPressed: isLastQuestion
                ? (canGoNext ? (onSubmit ?? onNext) : null)
                : (canGoNext ? onNext : null),
            icon: isLastQuestion
                ? Icons.check_circle_rounded
                : Icons.arrow_forward_rounded,
            label: isLastQuestion ? 'Submit Quiz' : 'Next',
            isPrimary: true,
            colorScheme: colorScheme,
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class _CompactButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _CompactButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 44, // Reduced height for compact design
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 18, // Smaller icon
          color: isEnabled
              ? (isPrimary ? colorScheme.onPrimary : colorScheme.onSurface)
              : colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isEnabled
                ? (isPrimary ? colorScheme.onPrimary : colorScheme.onSurface)
                : colorScheme.onSurface.withValues(alpha: 0.38),
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? (isPrimary
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHigh)
              : colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
          foregroundColor: isEnabled
              ? (isPrimary ? colorScheme.onPrimary : colorScheme.onSurface)
              : colorScheme.onSurface.withValues(alpha: 0.38),
          elevation: isPrimary && isEnabled ? 2 : 0,
          shadowColor:
              isPrimary ? colorScheme.primary.withValues(alpha: 0.3) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(
                    color: isEnabled
                        ? colorScheme.outline.withValues(alpha: 0.5)
                        : colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
