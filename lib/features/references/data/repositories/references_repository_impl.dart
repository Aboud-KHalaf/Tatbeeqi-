import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/references/data/datasources/mock_references_datasource.dart';
import 'package:tatbeeqi/features/references/domain/entities/reference.dart';
import 'package:tatbeeqi/features/references/domain/repositories/references_repository.dart';

class ReferencesRepositoryImpl implements ReferencesRepository {
  final ReferencesDataSource dataSource;

  ReferencesRepositoryImpl(this.dataSource);

  @override
     Future<Either<Failure,List<Reference>>> fetchReferences(String courseId) async {
     throw Exception();
  }
}
