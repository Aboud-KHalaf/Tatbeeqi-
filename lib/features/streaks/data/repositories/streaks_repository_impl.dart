import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_streak.dart';
import '../../domain/repositories/streaks_repository.dart';
import '../datasources/streaks_remote_datasource.dart';

class StreaksRepositoryImpl implements StreaksRepository {
  final StreaksRemoteDataSource remoteDataSource;
  final InternetConnectionChecker connectionChecker;

  StreaksRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, UserStreak>> getUserStreak(String userId) async {
    if (await connectionChecker.hasConnection) {
      try {
        final streak = await remoteDataSource.getUserStreak(userId);
        return Right(streak);
      } on ServerException catch (e) {
        return Left(ServerFailure( e.message));
      } catch (e) {
        return Left(ServerFailure( 'Unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure( 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateStreakOnLessonComplete(String userId) async {
    if (await connectionChecker.hasConnection) {
      try {
        await remoteDataSource.updateStreakOnLessonComplete(userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(  e.message));
      } catch (e) {
        return Left(ServerFailure(  'Failed to update streak'));
      }
    } else {
      return const Left(NetworkFailure(  'No internet connection'));
    }
  }
}
