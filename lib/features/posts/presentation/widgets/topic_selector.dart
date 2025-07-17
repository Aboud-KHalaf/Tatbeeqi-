import 'package:flutter/material.dart';

class TopicSelector extends StatelessWidget {
  final List<String> availableTopics;
  final List<String> selectedTopics;
  final Function(String) onTopicSelected;

  const TopicSelector({
    super.key,
    required this.availableTopics,
    required this.selectedTopics,
    required this.onTopicSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Topics', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: availableTopics.map((topic) {
            final isSelected = selectedTopics.contains(topic);
            return FilterChip(
              label: Text(topic),
              selected: isSelected,
              onSelected: (bool selected) {
                onTopicSelected(topic);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}