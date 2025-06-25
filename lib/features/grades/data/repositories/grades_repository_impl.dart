import 'package:tatbeeqi/features/grades/data/datasources/mock_grades_datasource.dart';
import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';
import 'package:tatbeeqi/features/grades/domain/repositories/grades_repository.dart';

class GradesRepositoryImpl implements GradesRepository {
  final MockGradesDataSource dataSource;

  GradesRepositoryImpl(this.dataSource);

  @override
  Future<void> insertGrade(Grade grade) async {
    // In a real implementation, you would convert the Grade entity to a GradeModel
    // and send it to the data source.
    print('Inserting grade: ${grade.id}');
    // No actual insertion in mock implementation
  }

  @override
  Future<List<Grade>> fetchGradesByLessonAndCourseId(String lessonId, String courseId) async {
    return dataSource.grades
        .where((grade) => grade.lessonId == lessonId && grade.courseId == courseId)
        .toList();
  }
}
