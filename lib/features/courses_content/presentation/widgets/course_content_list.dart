import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses_content/models/course_content_item.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/course_content_card.dart';

class CourseContentList extends StatelessWidget {
  final List<CourseContentItem> items;

  const CourseContentList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          return CourseContentCard(
            item: item,
            onTap: () {},
          );
        },
        childCount: items.length,
      ),
    );
  }
}
