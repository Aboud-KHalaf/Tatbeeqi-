import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/quiz/domain/entities/quiz_question.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_score_summary_card.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_result_list.dart' hide QuizScoreSummaryCard;
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_result_action_button.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
class ResultView extends StatelessWidget {
  static const String routeName = '/quiz_result';

  final int score;
  final Map<String, bool> results;
  final List<QuizQuestion> questions;
  final Map<String, String> userAnswers;

  const ResultView({
    Key? key,
    required this.score,
    required this.results,
    required this.questions,
    required this.userAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        final l10n = AppLocalizations.of(context)!;

    final colorScheme = Theme.of(context).colorScheme;
    final totalQuestions = questions.length;
    final passed = score >= (totalQuestions / 2); // Example passing threshold

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quizResultsTitle),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: QuizScoreSummaryCard(
                score: score,
                totalQuestions: totalQuestions,
                passed: passed,
              ),
            ),
            QuizResultList(
              questions: questions,
              results: results,
              userAnswers: userAnswers,
            ),
           const SliverToBoxAdapter(
              child: const QuizResultActionButton(),
            ),
          ],
        ),
      ),
    );
  }
}