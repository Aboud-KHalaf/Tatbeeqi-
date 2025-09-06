import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/feedbacks/domain/entities/feedback.dart';

abstract class FeedbackRepository {
  Future<Either<Failure, void>> submitFeedback(Feedback feedback);
  Future<Either<Failure, List<Feedback>>> getUserFeedbacks();
}
