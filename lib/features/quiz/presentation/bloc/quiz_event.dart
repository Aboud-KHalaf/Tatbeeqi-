part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class LoadQuiz extends QuizEvent {
  final int lessonId;
  const LoadQuiz(this.lessonId);

  @override
  List<Object> get props => [lessonId];
}

class SelectAnswer extends QuizEvent {
  final String questionId;
  final String answerId;

  const SelectAnswer(this.questionId, this.answerId);

  @override
  List<Object> get props => [questionId, answerId];
}

class NextQuestion extends QuizEvent {}

class PreviousQuestion extends QuizEvent {}

class SubmitQuiz extends QuizEvent {}
