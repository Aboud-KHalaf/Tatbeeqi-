part of 'grades_cubit.dart';

abstract class GradesState extends Equatable {
  const GradesState();

  @override
  List<Object?> get props => [];
}

class GradesInitial extends GradesState {}

class GradesLoading extends GradesState {}

class GradesLoaded extends GradesState {
  final List<Grade> grades;
  const GradesLoaded(this.grades);

  @override
  List<Object?> get props => [grades];
}

class GradesSaving extends GradesState {}

class GradesSaved extends GradesState {}

class GradesError extends GradesState {
  final String message;
  const GradesError(this.message);

  @override
  List<Object?> get props => [message];
}
