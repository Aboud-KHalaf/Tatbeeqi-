part of 'quiz_bloc.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<QuizQuestion> questions;
  final Map<String, String> userAnswers; // questionId -> answerId
  final int currentQuestionIndex;
  final int lessonId;

  const QuizLoaded({
    required this.questions,
    this.userAnswers = const {},
    this.currentQuestionIndex = 0,
    required this.lessonId,
  });

  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;

  @override
  List<Object> get props => [questions, userAnswers, currentQuestionIndex, lessonId];

  QuizLoaded copyWith({
    List<QuizQuestion>? questions,
    Map<String, String>? userAnswers,
    int? currentQuestionIndex,
    int? lessonId,
  }) {
    return QuizLoaded(
      questions: questions ?? this.questions,
      userAnswers: userAnswers ?? this.userAnswers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      lessonId: lessonId ?? this.lessonId,
    );
  }
}

class QuizCompleted extends QuizState {
  final int score;
  final Map<String, bool> results;
  final List<QuizQuestion> questions;
  final Map<String, String> userAnswers;

  const QuizCompleted({
    required this.score,
    required this.results,
    required this.questions,
    required this.userAnswers,
  });

  @override
  List<Object> get props => [score, results, questions, userAnswers];
}

class QuizError extends QuizState {
  final String error;

  const QuizError({required this.error});

  @override
  List<Object> get props => [error];
}
