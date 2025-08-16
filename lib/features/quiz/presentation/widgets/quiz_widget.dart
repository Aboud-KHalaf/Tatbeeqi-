import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';
import 'package:tatbeeqi/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_empty_state.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_error_state.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_loaded_widget.dart';

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
    // Load the quiz once after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizBloc>().add(LoadQuiz(widget.lessonId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizBloc, QuizState>(
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
          return const QuizLoadingState();
        }

        if (state is QuizSubmitting) {
          return const QuizSubmittingState();
        }

        if (state is QuizError) {
          return QuizErrorState(
            onRetry: () => context.read<QuizBloc>().add(LoadQuiz(widget.lessonId)),
          );
        }

        if (state is QuizLoaded) {
          if (state.questions.isEmpty) {
            return const QuizEmptyState();
          }
          return QuizLoadedContent(state: state);
        }

        if (state is QuizCompleted) {
          return QuizCompletedState(state: state);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class QuizLoadingState extends StatelessWidget {
  const QuizLoadingState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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

class QuizSubmittingState extends StatelessWidget {
  const QuizSubmittingState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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

class QuizCompletedState extends StatelessWidget {
  final QuizCompleted state;

  const QuizCompletedState({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final percentage = (state.score / state.questions.length * 100).round();
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
              'Your Score: ${state.score}/${state.questions.length} ($percentage%)',
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
