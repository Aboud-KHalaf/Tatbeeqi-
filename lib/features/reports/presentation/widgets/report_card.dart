import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/reports/domain/entities/report.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback? onTap;

  const ReportCard({
    super.key,
    required this.report,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildReportTypeChip(context),
                  const Spacer(),
                  _buildStatusChip(context),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                report.reason,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(report.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (report.postId != null || report.lessonId != null) ...[
                    const SizedBox(width: 16),
                    Icon(
                      report.reportType == ReportType.post
                          ? Icons.article_outlined
                          : Icons.school_outlined,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      report.reportType == ReportType.post
                          ? 'Post: ${report.postId?.substring(0, 8)}...'
                          : 'Lesson: ${report.lessonId}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportTypeChip(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isPost = report.reportType == ReportType.post;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPost 
            ? colorScheme.primaryContainer.withValues(alpha: 0.5)
            : colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPost ? Icons.article_outlined : Icons.school_outlined,
            size: 14,
            color: isPost 
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            isPost ? l10n.post : l10n.lesson,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isPost 
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (report.status) {
      case ReportStatus.pending:
        backgroundColor = colorScheme.tertiary.withValues(alpha: 0.2);
        textColor = colorScheme.onTertiaryContainer;
        statusText = l10n.pending;
        break;
      case ReportStatus.reviewed:
        backgroundColor = colorScheme.primary.withValues(alpha: 0.2);
        textColor = colorScheme.onPrimaryContainer;
        statusText = l10n.reviewed;
        break;
      case ReportStatus.dismissed:
        backgroundColor = colorScheme.error.withValues(alpha: 0.2);
        textColor = colorScheme.onErrorContainer;
        statusText = l10n.dismissed;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
