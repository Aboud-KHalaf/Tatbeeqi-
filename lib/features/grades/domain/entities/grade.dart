import 'package:equatable/equatable.dart';

class Grade extends Equatable {
  final String id;
  final String lessonId;
  final String quizId;
  final String courseId;
  final String lectureId;
  final String studentId;
  final double score;
  final DateTime submissionDate;

  const Grade({
    required this.id,
    required this.lessonId,
    required this.quizId,
    required this.lectureId, 
    required this.courseId,
    required this.studentId,
    required this.score,
    required this.submissionDate,
  });

  @override
  List<Object?> get props => [id, lessonId, courseId, lectureId, studentId, score, submissionDate];
}
