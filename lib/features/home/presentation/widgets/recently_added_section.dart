import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

// Dummy model
class RecentItem {
  final String title;
  final String type; // e.g., 'PDF', 'Video'
  final IconData icon;
  final String? subtitle;

  RecentItem({
    required this.title,
    required this.type,
    required this.icon,
    this.subtitle,
  });
}

class RecentlyAddedSection extends StatelessWidget {
  const RecentlyAddedSection({super.key});

  // Replace with actual data
  List<RecentItem> _getRecentItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      RecentItem(
        title: l10n.homeAdvancedSoftwareEngineering,
        type: 'PDF',
        icon: Icons.picture_as_pdf_outlined,
        subtitle: 'Chapter 5: Design Patterns',
      ),
      RecentItem(
        title: 'Data Structures',
        type: 'Video',
        icon: Icons.play_circle_outline,
        subtitle: 'Binary Trees Explained',
      ),
      RecentItem(
        title: 'Algorithm Analysis',
        type: 'Article',
        icon: Icons.article_outlined,
        subtitle: 'Time Complexity Guide',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final recentItems = _getRecentItems(context);

    if (recentItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: recentItems.take(3).map((item) => _buildRecentItem(
        context,
        item,
        colorScheme,
        textTheme,
      )).toList(),
    );
  }

  Widget _buildRecentItem(
    BuildContext context,
    RecentItem item,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    // Derive proper MD3 colors for the item type
    final (containerColor, onContainerColor) = _getTypeColors(item.type, colorScheme);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            // TODO: Implement action (e.g., open PDF)
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // Use MD3 surface container tokens instead of semi-transparent variants
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // Use container color for the type badge background
                    color: containerColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    item.icon,
                    // Content on container should use on*Container
                    color: onContainerColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.type,
                    style: textTheme.labelSmall?.copyWith(
                      color: onContainerColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Returns a tuple of (container, onContainer) for the given type
  (Color, Color) _getTypeColors(String type, ColorScheme colorScheme) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return (colorScheme.errorContainer, colorScheme.onErrorContainer);
      case 'video':
        return (colorScheme.primaryContainer, colorScheme.onPrimaryContainer);
      case 'article':
        return (colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer);
      default:
        return (colorScheme.secondaryContainer, colorScheme.onSecondaryContainer);
    }
  }
}
