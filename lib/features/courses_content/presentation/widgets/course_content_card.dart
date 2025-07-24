import 'package:flutter/material.dart';
import '../course_content_item.dart';

class CourseContentCard extends StatelessWidget {
  final CourseContentItem item;
  final VoidCallback onTap;

  const CourseContentCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: colorScheme.primary.withValues(alpha: .05),
        highlightColor: colorScheme.primary.withValues(alpha: .03),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha:0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // أيقونة المحتوى
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: item.isCompleted
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: item.isCompleted
                        ? Icon(Icons.check, color: colorScheme.onPrimary)
                        : Icon(
                            item.icon,
                            color: item.type == ContentType.video
                                ? Colors.red
                                : colorScheme.onSurfaceVariant,
                          ),
                  ),
                ),

                const SizedBox(width: 16),

                // العنوان والنوع والمدة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(color: Theme.of(context).primaryColor)
                              ],
                            ),
                            child: Text(
                              _getTypeText(item.type),
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${item.durationMinutes}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // زر التحميل (اختياري)
                if (item.isDownloadable)
                  IconButton(
                    icon: Icon(Icons.download_outlined,
                        color: colorScheme.primary),
                    onPressed: () {},
                    tooltip: 'تحميل',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTypeText(ContentType type) {
    switch (type) {
      case ContentType.video:
        return 'فيديو';
      case ContentType.assignment:
        return 'واجب';
      case ContentType.reading:
        return 'قراءة';
      case ContentType.quiz:
        return 'اختبار';
    }
  }
}
