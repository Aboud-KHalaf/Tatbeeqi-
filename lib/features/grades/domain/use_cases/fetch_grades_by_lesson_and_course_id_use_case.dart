import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';
import 'package:tatbeeqi/features/grades/domain/repositories/grades_repository.dart';

class FetchGradesByLessonAndCourseIdUseCase {
  final GradesRepository repository;

  FetchGradesByLessonAndCourseIdUseCase(this.repository);

  Future<List<Grade>> call(String lessonId, String courseId) {
    return repository.fetchGradesByLessonAndCourseId(lessonId, courseId);
  }
}
