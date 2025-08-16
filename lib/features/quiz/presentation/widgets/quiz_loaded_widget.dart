import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/question_widget.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_progress_bar.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/compact_navigation_buttons.dart';

class QuizLoadedContent extends StatelessWidget {
  final QuizLoaded state;

  const QuizLoadedContent({
    Key? key,
    required this.state,
  }) : super(key: key);

  void _showSubmitConfirmationDialog(BuildContext context, QuizLoaded state) {
    final answeredCount = state.userAnswers.length;
    final totalCount = state.questions.length;
    // Capture the bloc instance from the current (outer) context
    final quizBloc = context.read<QuizBloc>();

    if (answeredCount < totalCount) {
      _showIncompleteQuizDialog(context, answeredCount, totalCount);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Submit Quiz'),
        content: Text(
          'Are you sure you want to submit your quiz?\n\n'
          'You have answered all $totalCount questions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              print("submiting the quiz");
              // Dispatch on the captured bloc instance to guarantee same Bloc
              quizBloc.add(SubmitQuiz());
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showIncompleteQuizDialog(
      BuildContext context, int answered, int total) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Incomplete Quiz'),
        content: Text(
          'You have answered $answered out of $total questions.\n\n'
          'Please answer all questions before submitting.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Continue Quiz'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final question = state.questions[state.currentQuestionIndex];
    final isLastQuestion =
        state.currentQuestionIndex == state.questions.length - 1;
    final canSubmitQuiz = state.userAnswers.length == state.questions.length;
    final canGoNext = state.userAnswers.containsKey(question.id);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: QuizProgressBar(
              currentQuestionIndex: state.currentQuestionIndex,
              totalQuestions: state.questions.length,
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              children: [
                Expanded(
                  child: QuestionWidget(
                    question: question,
                    selectedAnswerId: state.userAnswers[question.id],
                    onAnswerSelected: (answerId) {
                      HapticFeedback.selectionClick();
                      context
                          .read<QuizBloc>()
                          .add(SelectAnswer(question.id, answerId));
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: CompactNavigationButtons(
                      canGoBack: state.currentQuestionIndex > 0,
                      canGoNext: canGoNext,
                      isLastQuestion: isLastQuestion,
                      colorScheme: colorScheme,
                      theme: theme,
                      onPrevious: state.currentQuestionIndex > 0
                          ? () {
                              HapticFeedback.lightImpact();
                              context.read<QuizBloc>().add(PreviousQuestion());
                            }
                          : null,
                      onNext: canGoNext && !isLastQuestion
                          ? () {
                              HapticFeedback.lightImpact();
                              context.read<QuizBloc>().add(NextQuestion());
                            }
                          : null,
                      onSubmit: isLastQuestion && canSubmitQuiz
                          ? () {
                              HapticFeedback.mediumImpact();
                              _showSubmitConfirmationDialog(context, state);
                            }
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
