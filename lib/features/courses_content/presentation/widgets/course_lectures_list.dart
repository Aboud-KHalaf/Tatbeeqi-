import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/lecture_item.dart';

class CourseLecturesList extends StatelessWidget {
  const CourseLecturesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المحاضرة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: LectureItem(
                  moduleNumber: index + 1,
                  isActive: index + 1 == 2,
                  isCompleted: index + 1 < 2,
                  onTap: () {
                    // Navigation or logic here
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
