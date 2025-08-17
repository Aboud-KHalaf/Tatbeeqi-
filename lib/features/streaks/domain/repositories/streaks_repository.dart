import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_streak.dart';

abstract class StreaksRepository {
  Future<Either<Failure, UserStreak>> getUserStreak();
  Future<Either<Failure, void>> updateStreakOnLessonComplete(String userId);
}
