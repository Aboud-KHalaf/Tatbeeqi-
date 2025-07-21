import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostCardShimmer extends StatelessWidget {
  const PostCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    final shimmerBaseColor = colorScheme.onSurface.withOpacity(0.3);
    final shimmerHighlightColor = colorScheme.onSurfaceVariant.withOpacity(0.6);

    const placeholderColor = Colors.white;

    Widget shimmerContainer(
        {required double width, required double height, double radius = 4}) {
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
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: colorScheme.outline.withOpacity(0.12)),
      ),
      child: Shimmer.fromColors(
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info row
            Row(
              children: [
                const CircleAvatar(
                    radius: 20, backgroundColor: placeholderColor),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerContainer(width: 120, height: 14),
                    const SizedBox(height: 4),
                    shimmerContainer(width: 80, height: 12),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Text content
            shimmerContainer(width: double.infinity, height: 16),
            const SizedBox(height: 8),
            shimmerContainer(width: screenWidth * 0.7, height: 16),
            const SizedBox(height: 8),
            shimmerContainer(width: screenWidth * 0.5, height: 16),
            const SizedBox(height: 16),

            // Image placeholder
            shimmerContainer(width: double.infinity, height: 200, radius: 12),
            const SizedBox(height: 16),

            // Action buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (_) => shimmerContainer(width: 80, height: 32, radius: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A shimmer list for multiple loading post cards
class PostsShimmerList extends StatelessWidget {
  final int itemCount;

  const PostsShimmerList({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, _) => const PostCardShimmer(),
        childCount: itemCount,
      ),
    );
  }
}
