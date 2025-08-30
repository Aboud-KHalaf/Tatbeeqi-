import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CourseCardShimmer extends StatelessWidget {
  const CourseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final baseColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    final highlightColor = theme.scaffoldBackgroundColor;
    const placeholderColor = Colors.white;

    Widget box({required double width, required double height, double r = 8}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: placeholderColor,
          borderRadius: BorderRadius.circular(r),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Icon circle container similar to CourseCardHeader
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.secondaryContainer,
                ),
                child: const CircleAvatar(
                  radius: 21, // matches icon size 42
                  backgroundColor: placeholderColor,
                ),
              ),
              const SizedBox(height: 12.0),
              // Title (2 lines max in real card). Here two shimmer lines centered
              box(width: 120, height: 14, r: 6),
              const SizedBox(height: 6),
              box(width: 160, height: 14, r: 6),

              const Spacer(),

              // Progress bar skeleton similar to CourseCardProgress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorScheme.surfaceContainerHighest,
                          ),
                        ),
                        // Simulate partial progress fill
                        FractionallySizedBox(
                          widthFactor: 0.6,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: placeholderColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  box(width: 28, height: 12, r: 4), // percentage label placeholder
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
