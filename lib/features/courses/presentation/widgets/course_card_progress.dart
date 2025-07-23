import 'package:flutter/material.dart';

class CourseCardProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String progressText;

  const CourseCardProgress({
    super.key,
    required this.progress,
    required this.progressText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmpty = progress <= 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Progress Bar
        Expanded(
          child: Stack(
            children: [
              // Background track
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),

              // Progress fill
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: isEmpty
                        ? null
                        : LinearGradient(
                            colors: _getProgressGradientColors(context),
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                    color: isEmpty
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 4.0),

        // Progress Text
        Text(
          progressText,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isEmpty ? theme.hintColor : theme.colorScheme.primary,
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }

  List<Color> _getProgressGradientColors(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return [
      primary.withValues(alpha: 0.9),
      primary.withValues(alpha: 0.6),
    ];
  }
}
