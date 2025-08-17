import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/streaks_repository.dart';

class UpdateStreakOnLessonComplete implements UseCase<void, UpdateStreakParams> {
  final StreaksRepository repository;

  UpdateStreakOnLessonComplete(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateStreakParams params) async {
    return await repository.updateStreakOnLessonComplete(params.userId);
  }
}

class UpdateStreakParams {
  final String userId;

  UpdateStreakParams({required this.userId});
}
