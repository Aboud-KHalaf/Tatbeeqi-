// features/quiz/presentation/widgets/question_widget.dart

import 'package:flutter/material.dart';

import 'package:tatbeeqi/features/quiz/domain/entities/quiz_answer.dart'; // Assuming you have an Answer entity
import 'package:tatbeeqi/features/quiz/domain/entities/quiz_question.dart';

class QuestionWidget extends StatelessWidget {
  final QuizQuestion question;
  final String? selectedAnswerId;
  final ValueChanged<String> onAnswerSelected;

  const QuestionWidget({
    Key? key,
    required this.question,
    this.selectedAnswerId,
    required this.onAnswerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Question Card
        Card(
          elevation: 6, // Increased elevation for a more prominent card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.only(bottom: 24.0),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              question.questionText,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Answer Options (as Cards)
        ...question.answers.map((answer) {
          final isSelected = selectedAnswerId == answer.id;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AnswerOptionCard(
              answer: answer,
              isSelected: isSelected,
              onTap: () => onAnswerSelected(answer.id),
            ),
          );
        }).toList(),
      ],
    );
  }
}

// features/quiz/presentation/widgets/answer_option_card.dart

class AnswerOptionCard extends StatelessWidget {
  final QuizAnswer answer;
  final bool isSelected;
  final VoidCallback onTap;

  const AnswerOptionCard({
    Key? key,
    required this.answer,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200), // Smooth transition for selection
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary.withValues(alpha: 0.15) : colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.4),
          width: isSelected ? 2.5 : 1.5, // Thicker border when selected
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.08),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent, // Make Material transparent to show AnimatedContainer's color
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    answer.answerText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}