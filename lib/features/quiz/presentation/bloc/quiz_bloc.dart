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
    try {
      final questions = await getQuizQuestionsUseCase(event.lessonId);
      emit(QuizLoaded(questions: questions));
    } catch (e) {
      emit(QuizInitial()); // Or a specific error state
    }
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
        emit(currentState.copyWith(currentQuestionIndex: currentState.currentQuestionIndex + 1));
      }
    }
  }

  void _onPreviousQuestion(PreviousQuestion event, Emitter<QuizState> emit) {
     if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
      if (currentState.currentQuestionIndex > 0) {
        emit(currentState.copyWith(currentQuestionIndex: currentState.currentQuestionIndex - 1));
      }
    }
  }

  Future<void> _onSubmitQuiz(SubmitQuiz event, Emitter<QuizState> emit) async {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;
       if (currentState.userAnswers.length != currentState.questions.length) {
        return;
      }
      final userAnswers = currentState.userAnswers.entries
          .map((e) => UserAnswer(questionId: e.key, selectedAnswerId: e.value))
          .toList();

      final results = await evaluateQuizAnswersUseCase(userAnswers);
      final score = results.values.where((isCorrect) => isCorrect).length;

      emit(QuizCompleted(
        score: score,
        results: results,
        questions: currentState.questions,
        userAnswers: currentState.userAnswers,
      ));
    }
  }
}
