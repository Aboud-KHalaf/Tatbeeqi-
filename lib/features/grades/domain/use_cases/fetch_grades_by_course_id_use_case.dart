import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';
import 'package:tatbeeqi/features/grades/domain/repositories/grades_repository.dart';
  
class FetchGradesByCourseIdUseCase extends UseCase<List<Grade>, String> {
  final GradesRepository repository;

  FetchGradesByCourseIdUseCase(this.repository);

  @override
  Future<Either<Failure, List<Grade>>> call(String params) {
    return repository.fetchGradesByCourseId(params);
  }
}