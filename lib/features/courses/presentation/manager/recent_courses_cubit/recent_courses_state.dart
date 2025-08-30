import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';

abstract class RecentCoursesState extends Equatable {
  const RecentCoursesState();

  @override
  List<Object?> get props => [];
}

class RecentCoursesInitial extends RecentCoursesState {}

class RecentCoursesLoading extends RecentCoursesState {}

class RecentCoursesLoaded extends RecentCoursesState {
  final List<Course> courses;
  const RecentCoursesLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

class RecentCoursesEmpty extends RecentCoursesState {}

class RecentCoursesError extends RecentCoursesState {
  final String message;
  const RecentCoursesError(this.message);

  @override
  List<Object?> get props => [message];
}
