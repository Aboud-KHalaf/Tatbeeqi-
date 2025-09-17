import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/quiz/domain/entities/quiz_question.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_score_summary_card.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_result_list.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_result_action_button.dart';

class ResultView extends StatefulWidget {
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
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  @override
  Widget build(BuildContext context) {
    final totalQuestions = widget.questions.length;
    final passed =
        widget.score >= (totalQuestions / 2); // Example passing threshold

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: QuizScoreSummaryCard(
                score: widget.score,
                totalQuestions: totalQuestions,
                passed: passed,
              ),
            ),
            QuizResultList(
              questions: widget.questions,
              results: widget.results,
              userAnswers: widget.userAnswers,
            ),
            const SliverToBoxAdapter(
              child: QuizResultActionButton(),
            ),
          ],
        ),
      ),
    );
  }
}
