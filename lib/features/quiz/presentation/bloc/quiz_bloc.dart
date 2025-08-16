import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/quiz_question.dart';
import '../../domain/entities/user_answer.dart';
import '../../domain/usecases/evaluate_quiz_answers.dart';
import '../../domain/usecases/get_quiz_questions.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetQuizQuestionsUseCase getQuizQuestionsUseCase;
  final EvaluateQuizAnswersUseCase evaluateQuizAnswersUseCase;

  QuizBloc({
    required this.getQuizQuestionsUseCase,
    required this.evaluateQuizAnswersUseCase,
  }) : super(QuizInitial()) {
    on<LoadQuiz>(_onLoadQuiz);
    on<SelectAnswer>(_onSelectAnswer);
    on<NextQuestion>(_onNextQuestion);
    on<PreviousQuestion>(_onPreviousQuestion);
    on<SubmitQuiz>(_onSubmitQuiz);
  }

  Future<void> _onLoadQuiz(LoadQuiz event, Emitter<QuizState> emit) async {
    emit(QuizLoading());

    final result = await getQuizQuestionsUseCase(event.lessonId);

    result.fold(
      (failure) {
        print('Quiz loading failed: ${failure.message}');
        emit(QuizError(error: failure.message));
      },
      (questions) {
        print('Quiz loaded successfully with ${questions.length} questions');
        emit(QuizLoaded(questions: questions, lessonId: event.lessonId));
      },
    );
  }

  void _onSelectAnswer(SelectAnswer event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      final newUserAnswers = Map<String, String>.from(currentState.userAnswers);
      newUserAnswers[event.questionId] = event.answerId;
      emit(currentState.copyWith(userAnswers: newUserAnswers));
    }
  }

  void _onNextQuestion(NextQuestion event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (!currentState.isLastQuestion) {
        emit(currentState.copyWith(
            currentQuestionIndex: currentState.currentQuestionIndex + 1));
      }
    }
  }

  void _onPreviousQuestion(PreviousQuestion event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (currentState.currentQuestionIndex > 0) {
        emit(currentState.copyWith(
            currentQuestionIndex: currentState.currentQuestionIndex - 1));
      }
    }
  }

  Future<void> _onSubmitQuiz(SubmitQuiz event, Emitter<QuizState> emit) async {
    if (state is! QuizLoaded) {
      emit(const QuizError(error: 'Quiz not loaded properly'));
      return;
    }

    final currentState = state as QuizLoaded;
    
    // Enhanced validation
    if (currentState.questions.isEmpty) {
      emit(const QuizError(error: 'No questions available to submit'));
      return;
    }

    if (currentState.userAnswers.length != currentState.questions.length) {
      final unanswered = currentState.questions.length - currentState.userAnswers.length;
      emit(QuizError(
        error: 'Please answer all questions before submitting ($unanswered remaining)'
      ));
      return;
    }

    // Emit submitting state
    emit(QuizSubmitting(
      questions: currentState.questions,
      userAnswers: currentState.userAnswers,
      lessonId: currentState.lessonId,
    ));

    try {
      final userAnswers = currentState.userAnswers.entries
          .map((entry) =>
              UserAnswer(questionId: entry.key, selectedAnswerId: entry.value))
          .toList();

      final result = await evaluateQuizAnswersUseCase(EvaluateQuizAnswersParams(
          lessonId: currentState.lessonId, userAnswers: userAnswers));

      result.fold(
        (failure) {
          print('Quiz evaluation failed: ${failure.message}');
          emit(QuizError(error: 'Failed to evaluate quiz: ${failure.message}'));
        },
        (results) {
          final score = results.values.where((isCorrect) => isCorrect).length;
          final totalQuestions = results.length;
          print('Quiz completed with score: $score/$totalQuestions');

          emit(QuizCompleted(
            score: score,
            results: results,
            questions: currentState.questions,
            userAnswers: currentState.userAnswers,
          ));
        },
      );
    } catch (e) {
      print('Unexpected error during quiz submission: $e');
      emit(QuizError(error: 'An unexpected error occurred. Please try again.'));
    }
  }
}
