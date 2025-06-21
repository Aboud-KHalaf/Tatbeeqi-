import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
class QuizResultCard extends StatelessWidget {
  final int questionNumber;
  final String questionText;
  final String selectedAnswer;
  final String correctAnswer;
  final bool isCorrect;

  const QuizResultCard({
    Key? key,
    required this.questionNumber,
    required this.questionText,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final borderColor = isCorrect
        ? const Color(0xFF81C784) // أخضر حدود
        : const Color(0xFFEF9A9A); // أحمر حدود

    final iconColor = isCorrect
        ? const Color(0xFF388E3C)
        : const Color(0xFFC62828);

    final textColor = isCorrect
        ? const Color(0xFF1B5E20)
        : const Color(0xFFB71C1C);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: iconColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.quizResultCardQuestion(questionNumber),
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            Text(
              questionText,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${l10n.quizResultCardYourAnswer} ',
                    style: textTheme.bodyLarge?.copyWith(
                    ),
                  ),
                  TextSpan(
                    text: selectedAnswer,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (!isCorrect)
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${l10n.quizResultCardCorrectAnswer} ',
                      style: textTheme.bodyLarge?.copyWith(
                      ),
                    ),
                    TextSpan(
                      text: correctAnswer,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
