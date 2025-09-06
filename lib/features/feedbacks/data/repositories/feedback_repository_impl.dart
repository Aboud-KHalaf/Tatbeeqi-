import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/feedbacks/data/datasources/feedback_remote_data_source.dart';
import 'package:tatbeeqi/features/feedbacks/data/models/feedback_model.dart';
import 'package:tatbeeqi/features/feedbacks/domain/entities/feedback.dart';
import 'package:tatbeeqi/features/feedbacks/domain/repositories/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource remoteDataSource;
  final InternetConnectionChecker connectionChecker;

  FeedbackRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, void>> submitFeedback(Feedback feedback) async {
    if (await connectionChecker.hasConnection) {
      try {
        final feedbackModel = FeedbackModel(
          id: feedback.id,
          userId: feedback.userId,
          type: feedback.type,
          title: feedback.title,
          description: feedback.description,
          screenshotUrl: feedback.screenshotUrl,
          deviceInfo: feedback.deviceInfo,
          appVersion: feedback.appVersion,
          createdAt: feedback.createdAt,
          status: feedback.status,
        );
        
        await remoteDataSource.submitFeedback(feedbackModel);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Feedback>>> getUserFeedbacks() async {
    if (await connectionChecker.hasConnection) {
      try {
        final feedbacks = await remoteDataSource.getUserFeedbacks();
        return Right(feedbacks);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
