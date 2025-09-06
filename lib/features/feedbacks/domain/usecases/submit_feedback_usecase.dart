import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/feedbacks/domain/entities/feedback.dart';
import 'package:tatbeeqi/features/feedbacks/domain/repositories/feedback_repository.dart';

class SubmitFeedbackUseCase implements UseCase<void, Feedback> {
  final FeedbackRepository repository;

  SubmitFeedbackUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Feedback params) async {
    return await repository.submitFeedback(params);
  }
}
