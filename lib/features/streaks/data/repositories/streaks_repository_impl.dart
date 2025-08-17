import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/network/network_info.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_streak.dart';
import '../../domain/repositories/streaks_repository.dart';
import '../datasources/streaks_remote_datasource.dart';

class StreaksRepositoryImpl implements StreaksRepository {
  final StreaksRemoteDataSource remoteDataSource;
  final NetworkInfo connectionChecker;

  StreaksRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, UserStreak>> getUserStreak() async {
    if (await connectionChecker.isConnected()) {
      try {
        final streak = await remoteDataSource.getUserStreak();
        return Right(streak);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(ServerFailure('Unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateStreakOnLessonComplete(
      String userId) async {
    if (await connectionChecker.isConnected()) {
      try {
        await remoteDataSource.updateStreakOnLessonComplete(userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(ServerFailure('Failed to update streak'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
