import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';

abstract class GradesRepository {
  Future<void> insertGrade(Grade grade);
  Future<List<Grade>> fetchGradesByLessonAndCourseId(String lessonId, String courseId);
}
