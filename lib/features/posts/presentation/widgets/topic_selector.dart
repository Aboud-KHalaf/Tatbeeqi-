import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class TopicSection extends StatelessWidget {
  final List<String> topics;
  final Function(String) onTopicSelected;

  const TopicSection({
    super.key,
    required this.topics,
    required this.onTopicSelected,
  });

  // Sample topics - in real app, this would come from API
  static const List<String> availableTopics = [
    'Technology',
    'Science',
    'Health',
    'Education',
    'Sports',
    'Travel',
    'Food',
    'Art',
    'Music',
    'Business',
    'Politics',
    'Environment',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.topic_outlined,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.topicsLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableTopics.map((topic) {
            final isSelected = topics.contains(topic);
            return FilterChip(
              label: Text(topic),
              selected: isSelected,
              onSelected: (_) => onTopicSelected(topic),
              backgroundColor: colorScheme.surface,
              selectedColor: colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
              ),
              side: BorderSide(
                color: isSelected ? colorScheme.primary : colorScheme.outline,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
