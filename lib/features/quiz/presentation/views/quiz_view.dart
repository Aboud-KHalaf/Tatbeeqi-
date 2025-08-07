import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';
import 'package:tatbeeqi/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/question_widget.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_progress_bar.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/compact_navigation_buttons.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_empty_state.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_error_state.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class QuizView extends StatefulWidget {
  static const String routeName = '/quiz';
  final int lessonId;

  const QuizView({Key? key, required this.lessonId}) : super(key: key);

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizBloc>().add(LoadQuiz(widget.lessonId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          l10n.quizTitle,
        ),
      ),
      body: BlocConsumer<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state is QuizCompleted) {
            HapticFeedback.lightImpact();
            context.pushReplacement(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
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
                              canGoNext: state.userAnswers.containsKey(state
                                  .questions[state.currentQuestionIndex].id),
                              isLastQuestion: state.currentQuestionIndex ==
                                  state.questions.length - 1,
                              onPrevious: state.currentQuestionIndex > 0
                                  ? () {
                                      HapticFeedback.lightImpact();
                                      context
                                          .read<QuizBloc>()
                                          .add(PreviousQuestion());
                                    }
                                  : null,
                              onNext: () {
                                HapticFeedback.lightImpact();
                                context.read<QuizBloc>().add(NextQuestion());
                              },
                              onSubmit: () {
                                HapticFeedback.mediumImpact();
                                context.read<QuizBloc>().add(SubmitQuiz());
                              },
                              colorScheme: colorScheme,
                              theme: theme,
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

          // Fallback for any other unexpected state or error
          return QuizErrorState(
            onRetry: () =>
                context.read<QuizBloc>().add(LoadQuiz(widget.lessonId)),
          );
        },
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  final ColorScheme colorScheme;

  const _LoadingState({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1200),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Loading Quiz...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we prepare your questions',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
