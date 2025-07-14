import 'package:flutter/material.dart';

class LectureItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundGradient = isActive || isCompleted
        ? LinearGradient(
            colors: isActive
                ? [
                    colorScheme.primary.withValues(alpha: 0.7),
                    colorScheme.primary,
                  ]
                : [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.85),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;

    final borderColor = isActive
        ? colorScheme.primary
        : isCompleted
            ? Colors.transparent
            : colorScheme.outline.withValues(alpha: 0.3);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: colorScheme.primary.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            gradient: backgroundGradient,
            color: (!isActive && !isCompleted)
                ? colorScheme.primary.withValues(alpha: 0.25)
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: (isActive || isCompleted)
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
            border: Border.all(
              color: borderColor,
              width: isActive ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              'المحاضرة $moduleNumber',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
