import 'package:tatbeeqi/features/grades/data/models/grade_model.dart';

class MockGradesDataSource {
  final List<GradeModel> grades = [
    GradeModel(
      id: '1',
      lessonId: '1',
      quizId: '1',
      lectureId: '1',
      courseId: '1',
      studentId: 'student1',
      score: 85.0,
      submissionDate: DateTime.now(),
    ),
    
  ];
}
