import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_streak.dart';
import '../repositories/streaks_repository.dart';

class GetUserStreak implements UseCase<UserStreak, GetUserStreakParams> {
  final StreaksRepository repository;

  GetUserStreak(this.repository);

  @override
  Future<Either<Failure, UserStreak>> call(GetUserStreakParams params) async {
    return await repository.getUserStreak(params.userId);
  }
}

class GetUserStreakParams {
  final String userId;

  GetUserStreakParams({required this.userId});
}
