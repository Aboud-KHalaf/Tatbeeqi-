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
    super.lessonTitle,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    // lessonTitle may come nested as { lessons: { title: ... } } or aliased as lesson_title
    String? title;
    final lessons = json['lessons'];
    if (lessons is Map<String, dynamic>) {
      final t = lessons['title'];
      if (t is String) title = t;
    }
    final aliased = json['lesson_title'];
    if (title == null && aliased is String) {
      title = aliased;
    }
    return GradeModel(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as int,
      quizId: json['quiz_id'] as int,
      lectureId: json['lecture_id'] as int,
      courseId: json['course_id'] as int,
      studentId: json['student_id'] as String,
      score: (json['score'] as num).toDouble(),
      submissionDate: DateTime.parse(json['submission_date']),
      lessonTitle: title,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lesson_id': lessonId,
      'quiz_id': quizId,
      'lecture_id': lectureId,
      'course_id': courseId,
      'student_id': studentId,
      'score': score,
      'submission_date': submissionDate.toIso8601String(),
    };
  }

  GradeModel copyWith({
    String? id,
    int? lessonId,
    int? quizId,
    int? courseId,
    int? lectureId,
    String? studentId,
    double? score,
    DateTime? submissionDate,
    String? lessonTitle,
  }) {
    return GradeModel(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      quizId: quizId ?? this.quizId,
      lectureId: lectureId ?? this.lectureId,
      courseId: courseId ?? this.courseId,
      studentId: studentId ?? this.studentId,
      score: score ?? this.score,
      submissionDate: submissionDate ?? this.submissionDate,
      lessonTitle: lessonTitle ?? this.lessonTitle,
    );
  }
}
