import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LectureCardShimmer extends StatelessWidget {
  const LectureCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final shimmerBaseColor =
        colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    final shimmerHighlightColor = colorScheme.onSurface.withValues(alpha: 0.6);
    const placeholderColor = Colors.white;

    Widget shimmerContainer(
        {double? width, double? height, double radius = 4}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: placeholderColor,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Shimmer.fromColors(
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              shimmerContainer(width: 48, height: 48, radius: 50),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(height: 16),
                    const SizedBox(height: 8),
                    shimmerContainer(height: 12, width: 200),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LectureShimmerList extends StatelessWidget {
  const LectureShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) => const LectureCardShimmer(),
    );
  }
}
