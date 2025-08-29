import 'package:flutter/material.dart';

class RetakeCoursesTitle extends StatelessWidget {
  const RetakeCoursesTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اضافة مقررات للاعادة', // Consider using AppLocalizations for "Retake Courses"
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
            letterSpacing: -0.25,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'اختر المقررات التي تريد ان تعيدها',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}