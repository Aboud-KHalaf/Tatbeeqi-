import 'package:flutter/material.dart';

class CourseScheduleCard extends StatelessWidget {
  final Map<String, dynamic> schedule;

  const CourseScheduleCard({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'الجدول الزمني',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (schedule['days'] != null) ...[
              _buildScheduleItem(
                context,
                'الأيام',
                (schedule['days'] as List).join(', '),
                Icons.calendar_view_week,
              ),
            ],
            if (schedule['time'] != null) ...[
              const SizedBox(height: 8),
              _buildScheduleItem(
                context,
                'الوقت',
                schedule['time'].toString(),
                Icons.access_time,
              ),
            ],
            if (schedule['duration'] != null) ...[
              const SizedBox(height: 8),
              _buildScheduleItem(
                context,
                'المدة',
                schedule['duration'].toString(),
                Icons.timelapse,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: colorScheme.secondary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
