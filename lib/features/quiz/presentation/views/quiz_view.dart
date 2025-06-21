// quiz_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';
import 'package:tatbeeqi/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/question_widget.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_progress_bar.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_navigation_buttons.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_empty_state.dart';
import 'package:tatbeeqi/features/quiz/presentation/widgets/quiz_error_state.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class QuizView extends StatefulWidget {
  static const String routeName = '/quiz';
  final String lessonId;

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
    });  }

  @override
  Widget build(BuildContext context) {
        final l10n = AppLocalizations.of(context)!;

   // final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quizTitle),
        // backgroundColor: colorScheme.primary,
        // foregroundColor: colorScheme.onPrimary,
        // centerTitle: true,
        // elevation: 4,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(16),
        //   ),
        // ),
      ),
      body: SafeArea(
        child: BlocConsumer<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state is QuizCompleted) {
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
              return const Center(child: CircularProgressIndicator());
            }

            if (state is QuizLoaded) {
              if (state.questions.isEmpty) {
                return const QuizEmptyState(); // Already localized in widget
              }

              final question = state.questions[state.currentQuestionIndex];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    QuizProgressBar(
                      currentQuestionIndex: state.currentQuestionIndex,
                      totalQuestions: state.questions.length,
                    ), // Widget will be localized
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: QuestionWidget(
                          question: question,
                          selectedAnswerId: state.userAnswers[question.id],
                          onAnswerSelected: (answerId) {
                            context.read<QuizBloc>().add(SelectAnswer(question.id, answerId));
                          },
                        ), // QuestionWidget will be localized
                      ),
                    ),
                    QuizNavigationButtons(
                      isFirstQuestion: state.currentQuestionIndex == 0,
                      isLastQuestion: state.isLastQuestion,
                      isAnswered: state.userAnswers.containsKey(question.id),
                      onPrevious: state.currentQuestionIndex > 0
                          ? () => context.read<QuizBloc>().add(PreviousQuestion())
                          : null,
                      onNext: !state.isLastQuestion && state.userAnswers.containsKey(question.id)
                          ? () => context.read<QuizBloc>().add(NextQuestion())
                          : null,
                      onSubmit: state.isLastQuestion && state.userAnswers.containsKey(question.id)
                          ? () => context.read<QuizBloc>().add(SubmitQuiz())
                          : null,
                    ), // Widget will be localized
                  ],
                ),
              );
            }

            // Fallback for any other unexpected state or error
            return QuizErrorState(
              onRetry: () => context.read<QuizBloc>().add(LoadQuiz(widget.lessonId)),
            ); // Widget will be localized
          },
        ),
      ),
    );
  }
}
