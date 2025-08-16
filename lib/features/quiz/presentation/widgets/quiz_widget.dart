import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';
import 'package:tatbeeqi/features/quiz/domain/entities/quiz_question.dart';
import 'package:tatbeeqi/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/question_widget.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_progress_bar.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/compact_navigation_buttons.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_empty_state.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_error_state.dart';

class QuizWidget extends StatefulWidget {
  final int lessonId;
 

  const QuizWidget({
    Key? key,
    required this.lessonId,
  }) : super(key: key);

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizBloc>().add(LoadQuiz(widget.lessonId));
    });
  }

  bool _canSubmitQuiz(QuizLoaded state) {
    // Check if all questions have been answered
    return state.userAnswers.length == state.questions.length;
  }

  void _showSubmitConfirmation(BuildContext context, QuizLoaded state) {
    final answeredCount = state.userAnswers.length;
    final totalCount = state.questions.length;

    if (answeredCount < totalCount) {
      // Show warning for incomplete quiz
      _showIncompleteQuizDialog(context, answeredCount, totalCount);
      return;
    }

    // Show confirmation dialog for complete quiz
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz'),
        content: Text(
          'Are you sure you want to submit your quiz?\n\n'
          'You have answered all $totalCount questions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<QuizBloc>().add(SubmitQuiz());
          
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
      builder: (context) => AlertDialog(
        title: const Text('Incomplete Quiz'),
        content: Text(
          'You have answered $answered out of $total questions.\n\n'
          'Please answer all questions before submitting.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
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

    return BlocConsumer<QuizBloc, QuizState>(
      listener: (context, state) {
        if (state is QuizCompleted) {
          
            context.pushNamed(
              AppRoutes.quizResultPath,
              extra: QuizResultArgs(
                score: state.score,
                results: state.results,
                questions: state.questions,
                userAnswers: state.userAnswers,
              ),
            );
          }
        
      },
      builder: (context, state) {
        if (state is QuizLoading || state is QuizInitial) {
          return _LoadingState(colorScheme: colorScheme);
        }

        if (state is QuizSubmitting) {
          return _SubmittingState(colorScheme: colorScheme);
        }

        if (state is QuizError) {
          return QuizErrorState(
            onRetry: () =>
                context.read<QuizBloc>().add(LoadQuiz(widget.lessonId)),
          );
        }

        if (state is QuizLoaded) {
          if (state.questions.isEmpty) {
            return const QuizEmptyState();
          }

          final question = state.questions[state.currentQuestionIndex];

          return CustomScrollView(
            slivers: [
              // Progress section as a sliver
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              // Question content as a sliver
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
                      // Compact navigation section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        margin: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outlineVariant
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: CompactNavigationButtons(
                            canGoBack: state.currentQuestionIndex > 0,
                            canGoNext: state.userAnswers.containsKey(
                                state.questions[state.currentQuestionIndex].id),
                            isLastQuestion: state.currentQuestionIndex ==
                                state.questions.length - 1,
                            colorScheme: colorScheme,
                            theme: theme,
                            onPrevious: state.currentQuestionIndex > 0
                                ? () {
                                    HapticFeedback.lightImpact();
                                    context
                                        .read<QuizBloc>()
                                        .add(PreviousQuestion());
                                  }
                                : null,
                            onNext: state.userAnswers.containsKey(state
                                    .questions[state.currentQuestionIndex].id)
                                ? () {
                                    HapticFeedback.lightImpact();
                                    context
                                        .read<QuizBloc>()
                                        .add(NextQuestion());
                                  }
                                : null,
                            onSubmit: _canSubmitQuiz(state)
                                ? () {
                                    HapticFeedback.mediumImpact();
                                    _showSubmitConfirmation(context, state);
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

        if (state is QuizCompleted) {
          return _QuizCompletedState(
            score: state.score,
            totalQuestions: state.questions.length,
            colorScheme: colorScheme,
            theme: theme,
          );
        }

        return Container();
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  final ColorScheme colorScheme;

  const _LoadingState({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1500),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                  strokeWidth: 3,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Loading Quiz...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}

class _SubmittingState extends StatelessWidget {
  final ColorScheme colorScheme;

  const _SubmittingState({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.9 + (0.1 * value),
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                  strokeWidth: 4,
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Submitting Quiz...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we evaluate your answers',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _QuizCompletedState extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _QuizCompletedState({
    required this.score,
    required this.totalQuestions,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions * 100).round();
    final isPassed = percentage >= 60;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPassed
                          ? colorScheme.primaryContainer
                          : colorScheme.errorContainer,
                    ),
                    child: Icon(
                      isPassed ? Icons.check_circle : Icons.cancel,
                      size: 60,
                      color: isPassed ? colorScheme.primary : colorScheme.error,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              isPassed ? 'Quiz Completed!' : 'Quiz Failed',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score: $score/$totalQuestions ($percentage%)',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isPassed ? colorScheme.primary : colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isPassed
                  ? 'Congratulations! You passed the quiz.'
                  : 'You need at least 60% to pass. Try again!',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
