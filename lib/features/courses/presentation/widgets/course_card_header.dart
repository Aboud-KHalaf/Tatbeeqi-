import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/helpers/courses_data_helper.dart';

class CourseCardHeader extends StatelessWidget {
  final CourseStyle iconData;
  final String title;

  const CourseCardHeader({
    super.key,
    required this.iconData,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconData.color.withValues(alpha: 0.2),
          ),
          child: Icon(
            iconData.icon,
            size: 42.0,
            color: iconData.color,
          ),
        ),
        const SizedBox(height: 12.0),
        Hero(
          tag: title,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14.0,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
