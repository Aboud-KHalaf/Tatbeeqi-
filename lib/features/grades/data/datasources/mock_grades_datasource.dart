import 'package:tatbeeqi/features/grades/data/models/grade_model.dart';

class MockGradesDataSource {
  final List<GradeModel> grades = [
    GradeModel(
      id: '1',
      lessonId: '1',
      courseId: '1',
      studentId: 'student1',
      score: 85.0,
      submissionDate: DateTime.now(),
    ),
    GradeModel(
      id: '2',
      lessonId: '1',
      courseId: '1',
      studentId: 'student2',
      score: 92.0,
      submissionDate: DateTime.now(),
    ),
    GradeModel(
      id: '3',
      lessonId: '2',
      courseId: '1',
      studentId: 'student1',
      score: 78.0,
      submissionDate: DateTime.now(),
    ),
  ];
}
