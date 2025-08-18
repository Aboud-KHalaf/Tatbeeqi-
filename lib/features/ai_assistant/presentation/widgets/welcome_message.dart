import 'package:flutter/material.dart';
import 'suggested_questions.dart';

class WelcomeMessage extends StatelessWidget {
  final String? lessonTitle;
  final String? lessonType;
  final Function(String) onQuestionSelected;

  const WelcomeMessage({
    super.key,
    this.lessonTitle,
    this.lessonType,
    required this.onQuestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'لبيب',
              style: textTheme.headlineLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'مرحباً! أنا لبيب، مساعدك الذكي للتعلم',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            lessonTitle != null
                ? 'اسألني أي سؤال حول الدرس وسأساعدك بكل سرور'
                : 'اسألني أي سؤال حول دراستك وسأساعدك بكل سرور',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SuggestedQuestions(
            lessonType: lessonType,
            onQuestionSelected: onQuestionSelected,
          ),
        ],
      ),
    );
  }
}
