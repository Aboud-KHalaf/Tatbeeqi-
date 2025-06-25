import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';
import 'package:tatbeeqi/features/grades/domain/repositories/grades_repository.dart';
export 'package:tatbeeqi/core/usecases/usecase.dart'; 



class UpdateGradeUseCase extends UseCase<void, Grade> {
  final GradesRepository repository;

  UpdateGradeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Grade grade) {
    return repository.updateGrade(grade);
  }
}