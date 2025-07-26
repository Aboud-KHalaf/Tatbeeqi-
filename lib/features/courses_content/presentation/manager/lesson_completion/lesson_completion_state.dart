part of 'lesson_completion_cubit.dart';

abstract class LessonCompletionState extends Equatable {
  const LessonCompletionState();

  @override
  List<Object> get props => [];
}

class LessonCompletionInitial extends LessonCompletionState {}

class LessonCompletionLoading extends LessonCompletionState {}

class LessonCompletionSuccess extends LessonCompletionState {}

class LessonCompletionError extends LessonCompletionState {
  final String message;

  const LessonCompletionError(this.message);

  @override
  List<Object> get props => [message];
}
