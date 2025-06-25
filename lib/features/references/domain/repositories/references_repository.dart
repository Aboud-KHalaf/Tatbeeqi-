import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/references/domain/entities/reference.dart';

abstract class ReferencesRepository {
  Future<Either<Failure,List<Reference>>> fetchReferences(String courseId);
}
