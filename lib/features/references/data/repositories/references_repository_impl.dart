import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/network/network_info.dart';
import 'package:tatbeeqi/features/references/data/datasources/mock_references_datasource.dart';
import 'package:tatbeeqi/features/references/domain/entities/reference.dart';
import 'package:tatbeeqi/features/references/domain/repositories/references_repository.dart';

class ReferencesRepositoryImpl implements ReferencesRepository {
  final ReferencesRemoteDataSource dataSource;
  final NetworkInfo networkInfo;

  ReferencesRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Reference>>> fetchReferences(String courseId) async {
    try {
      if (await networkInfo.isConnected()) {
        final intId = int.tryParse(courseId);
        if (intId == null) {
          return const Left(InvalidInputFailure('Invalid courseId provided'));
        }
        final models = await dataSource.fetchReferencesByCourseId(intId);
        return Right(models);
      } else {
        return const Left(NetworkFailure());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
