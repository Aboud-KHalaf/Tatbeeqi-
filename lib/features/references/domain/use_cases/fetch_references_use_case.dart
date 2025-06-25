import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/references/domain/entities/reference.dart';
import 'package:tatbeeqi/features/references/domain/repositories/references_repository.dart';

class FetchReferencesUseCase extends UseCase<List<Reference>,String>{
  final ReferencesRepository repository;

  FetchReferencesUseCase(this.repository);

@override
Future<Either<Failure, List<Reference>>> call(String courseId) {
  return repository.fetchReferences(courseId);
}
}
