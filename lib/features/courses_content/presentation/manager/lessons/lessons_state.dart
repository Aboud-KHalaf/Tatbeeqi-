part of 'lessons_cubit.dart';

abstract class LessonsState extends Equatable {
  const LessonsState();

  @override
  List<Object> get props => [];
}

class LessonsInitial extends LessonsState {}

class LessonsLoading extends LessonsState {}

class LessonsLoaded extends LessonsState {
  final List<Lesson> lessons;

  const LessonsLoaded(this.lessons);

  @override
  List<Object> get props => [lessons];
}

class LessonsError extends LessonsState {
  final String message;

  const LessonsError(this.message);

  @override
  List<Object> get props => [message];
}
