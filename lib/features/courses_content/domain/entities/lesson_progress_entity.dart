import 'package:equatable/equatable.dart';

class LessonProgress extends Equatable {
  final String userId;
  final int lessonId;
  final bool isCompleted;
  final DateTime? completedAt;

  const LessonProgress({
    required this.userId,
    required this.lessonId,
    required this.isCompleted,
    this.completedAt,
  });

  @override
  List<Object?> get props => [userId, lessonId, isCompleted, completedAt];
}
