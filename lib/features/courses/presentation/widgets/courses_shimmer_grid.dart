import 'package:flutter/material.dart';
  import 'package:tatbeeqi/features/courses/presentation/widgets/course_card_shimmer.dart';

class CoursesShimmerGridWidget extends StatelessWidget {
  final bool isTablet;
  final int selectedTabIndex;

  const CoursesShimmerGridWidget({
    super.key,
    required this.isTablet,
    required this.selectedTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 12.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return const CourseCardShimmer();
        },
        childCount: 12,
      ),
    );
  }
}
