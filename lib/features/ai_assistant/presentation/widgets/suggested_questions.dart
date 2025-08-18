import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuggestedQuestions extends StatelessWidget {
  final String? lessonType;
  final Function(String) onQuestionSelected;

  const SuggestedQuestions({
    super.key,
    this.lessonType,
    required this.onQuestionSelected,
  });

  List<String> _getSuggestedQuestions() {
    final normalizedType = _normalizedLessonType();
    
    switch (normalizedType) {
      case 'voice':
      case 'video':
        return [
          'Summarize the main points of this lesson',
          'What are the key concepts covered?',
          'Can you explain the most important part?',
          'How can I apply what I learned?',
        ];
      case 'pdf':
        return [
          'What are the main topics in this document?',
          'Can you explain the key concepts?',
          'What should I focus on studying?',
          'Are there any important formulas or definitions?',
        ];
      case 'reading':
        return [
          'Explain this concept in simple terms',
          'What are the key points to remember?',
          'Can you give me examples?',
          'How does this relate to other topics?',
        ];
      case 'quiz':
        return [
          'Help me understand this topic better',
          'What concepts should I review?',
          'Can you explain the correct answers?',
          'How can I improve my understanding?',
        ];
      default:
        return [
          'Explain this concept in simple terms',
          'What are the key points to remember?',
          'Can you give me examples?',
          'How does this relate to other topics?',
        ];
    }
  }

  String? _normalizedLessonType() {
    final t = lessonType?.toLowerCase();
    if (t == null) return null;
    final parts = t.split('.');
    return parts.isNotEmpty ? parts.last : t;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final suggestions = _getSuggestedQuestions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggested questions:',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((suggestion) {
            return ActionChip(
              label: Text(suggestion),
              onPressed: () {
                HapticFeedback.selectionClick();
                onQuestionSelected(suggestion);
              },
              backgroundColor: colorScheme.surfaceContainerHigh,
              labelStyle: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              side: BorderSide.none,
            );
          }).toList(),
        ),
      ],
    );
  }
}
