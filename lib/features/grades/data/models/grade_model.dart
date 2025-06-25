import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';

class GradeModel extends Grade {
  const GradeModel({
    required super.id,
    required super.lessonId,
    required super.quizId,
    required super.lectureId,
    required super.courseId,
    required super.studentId,
    required super.score,
    required super.submissionDate,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(  
      id: json['id'],
      lessonId: json['lessonId'],
      quizId: json['quizId'],
      lectureId: json['lectureId'],
      courseId: json['courseId'],
      studentId: json['studentId'],
      score: json['score'],
      submissionDate: DateTime.parse(json['submissionDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'quizId': quizId,
      'lectureId': lectureId,
      'courseId': courseId,
      'studentId': studentId,
      'score': score,
      'submissionDate': submissionDate.toIso8601String(),
    };
  }
}
