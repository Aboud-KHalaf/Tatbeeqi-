import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CreatePostBarShimmer extends StatelessWidget {
  const CreatePostBarShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final shimmerBaseColor = colorScheme.onSurfaceVariant.withOpacity(0.3);
    final shimmerHighlightColor = colorScheme.onSurface.withOpacity(0.6);
    const placeholderColor = Colors.white;

    Widget shimmerContainer({
      required double width,
      required double height,
      double radius = 4,
    }) {
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
      margin: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                    radius: 22, backgroundColor: placeholderColor),
                const SizedBox(width: 16),
                Expanded(
                  child: shimmerContainer(
                    width: double.infinity,
                    height: 52,
                    radius: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: shimmerContainer(
                      width: 88,
                      height: 44,
                      radius: 12,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
