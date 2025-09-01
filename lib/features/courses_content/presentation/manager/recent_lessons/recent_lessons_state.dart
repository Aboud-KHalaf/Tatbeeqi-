import 'package:equatable/equatable.dart';
import '../../../domain/entities/lesson_entity.dart';

abstract class RecentLessonsState extends Equatable {
  const RecentLessonsState();

  @override
  List<Object?> get props => [];
}

class RecentLessonsInitial extends RecentLessonsState {}

class RecentLessonsLoading extends RecentLessonsState {}

class RecentLessonsEmpty extends RecentLessonsState {}

class RecentLessonsLoaded extends RecentLessonsState {
  final List<Lesson> lessons;
  const RecentLessonsLoaded(this.lessons);

  @override
  List<Object?> get props => [lessons];
}

class RecentLessonsError extends RecentLessonsState {
  final String message;
  const RecentLessonsError(this.message);

  @override
  List<Object?> get props => [message];
}
