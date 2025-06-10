import 'package:flutter/material.dart';

class CourseDescriptionSection extends StatelessWidget {
  const CourseDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الخدمات الخلفية وقواعد البيانات في تطبيقات الهاتف',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تعرّفك هذه الوحدة على استخدام قواعد البيانات في تطوير تطبيقات الهاتف المحمول. حيث تُقارن بين نوعين من قواعد البيانات: المضمّنة والبعيدة، ثم تركّز على استخداماتها في تطوير التطبيقات.',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
