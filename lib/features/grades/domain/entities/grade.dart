import 'package:equatable/equatable.dart';

class Grade extends Equatable {
  final String id;
  final int lessonId;
  final int quizId;
  final int courseId;
  final int lectureId;
  final String studentId;
  final double score;
  final DateTime submissionDate;
  // Optional denormalized field fetched via join with lessons
  final String? lessonTitle;

  const Grade({
    required this.id,
    required this.lessonId,
    required this.quizId,
    required this.lectureId,
    required this.courseId,
    required this.studentId,
    required this.score,
    required this.submissionDate,
    this.lessonTitle,
  });

  @override
  List<Object?> get props => [
        id,
        lessonId,
        quizId,
        courseId,
        lectureId,
        studentId,
        score,
        submissionDate,
        lessonTitle,
      ];
}
