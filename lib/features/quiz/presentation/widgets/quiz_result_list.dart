import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_result_card.dart';
import 'package:tatbeeqi/features/quiz/domain/entities/quiz_question.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
class QuizResultList extends StatelessWidget {
  final List<QuizQuestion> questions;
  final Map<String, bool> results;
  final Map<String, String> userAnswers;
  const QuizResultList({
    Key? key,
    required this.questions,
    required this.results,
    required this.userAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        final l10n = AppLocalizations.of(context)!;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final question = questions[index];
            final isCorrect = results[question.id] ?? false;
            final selectedAnswerId = userAnswers[question.id];
            final String selectedAnswerText = selectedAnswerId != null
                ? question.answers
                    .where((a) => a.id == selectedAnswerId)
                    .map((a) => a.answerText)
                    .firstOrNull ?? l10n.quizResultCardNoAnswer
                : l10n.quizResultCardNoAnswer;
            final correctAnswerText =
                question.answers.firstWhere((a) => a.isCorrect).answerText;
            return QuizResultCard(
              questionNumber: index + 1,
              questionText: question.questionText,
              selectedAnswer: selectedAnswerText,
              correctAnswer: correctAnswerText,
              isCorrect: isCorrect,
            );
          },
          childCount: questions.length,
        ),
      ),
    );
  }
}
