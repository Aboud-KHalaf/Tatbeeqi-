import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/feedbacks/domain/entities/feedback.dart';
import 'package:tatbeeqi/features/feedbacks/domain/repositories/feedback_repository.dart';

class GetUserFeedbacksUseCase implements UseCase<List<Feedback>, NoParams> {
  final FeedbackRepository repository;

  GetUserFeedbacksUseCase(this.repository);

  @override
  Future<Either<Failure, List<Feedback>>> call(NoParams params) async {
    return await repository.getUserFeedbacks();
  }
}
