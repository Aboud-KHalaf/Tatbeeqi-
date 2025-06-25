import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';
import 'package:tatbeeqi/features/grades/domain/repositories/grades_repository.dart';

class InsertGradeUseCase {
  final GradesRepository repository;

  InsertGradeUseCase(this.repository);

  Future<void> call(Grade grade) {
    return repository.insertGrade(grade);
  }
}
