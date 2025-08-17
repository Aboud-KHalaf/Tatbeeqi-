import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_streak.dart';
import '../repositories/streaks_repository.dart';

class GetUserStreak implements UseCase<UserStreak, NoParams> {
  final StreaksRepository repository;

  GetUserStreak(this.repository);

  @override
  Future<Either<Failure, UserStreak>> call(NoParams params) async {
    return await repository.getUserStreak();
  }
}


