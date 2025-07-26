part of 'lectures_cubit.dart';

abstract class LecturesState extends Equatable {
  const LecturesState();

  @override
  List<Object> get props => [];
}

class LecturesInitial extends LecturesState {}

class LecturesLoading extends LecturesState {}

class LecturesLoaded extends LecturesState {
  final List<Lecture> lectures;

  const LecturesLoaded(this.lectures);

  @override
  List<Object> get props => [lectures];
}

class LecturesError extends LecturesState {
  final String message;

  const LecturesError(this.message);

  @override
  List<Object> get props => [message];
}
