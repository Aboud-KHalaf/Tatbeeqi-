import 'package:flutter/material.dart';

class CourseResourcesCard extends StatelessWidget {
  const CourseResourcesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'موارد الدورة',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              // الموارد الإضافية ستُضاف هنا لاحقًا
            ],
          ),
        ),
      ),
    );
  }
}
