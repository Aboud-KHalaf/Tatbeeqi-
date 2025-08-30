import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CoursesTabBarShimmer extends StatelessWidget {
  const CoursesTabBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final baseColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    final highlightColor = theme.scaffoldBackgroundColor;
    final surfaceColor = colorScheme.surfaceContainerHigh;

    Widget tabPill() {
      return Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Row(
            children: [
              Expanded(child: tabPill()),
              const SizedBox(width: 6),
              Expanded(child: tabPill()),
              const SizedBox(width: 6),
              Expanded(child: tabPill()),
            ],
          ),
        ),
      ),
    );
  }
}
