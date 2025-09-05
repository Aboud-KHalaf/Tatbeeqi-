import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/entities/course_details.dart';

abstract class CourseDetailsState extends Equatable {
  const CourseDetailsState();

  @override
  List<Object?> get props => [];
}

class CourseDetailsInitial extends CourseDetailsState {}

class CourseDetailsLoading extends CourseDetailsState {}

class CourseDetailsSuccess extends CourseDetailsState {
  final CourseDetails courseDetails;

  const CourseDetailsSuccess(this.courseDetails);

  @override
  List<Object?> get props => [courseDetails];
}

class CourseDetailsError extends CourseDetailsState {
  final String message;

  const CourseDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
