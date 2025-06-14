import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/app_notification.dart';
import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class SendNotificationByTopicsUsecase {
  final NotificationsRepository repository;
  SendNotificationByTopicsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required AppNotification notification,
    required List<String> topics,
  }) async {
    return repository.sendNotificationByTopics(
      notification: notification,
      topics: topics,
    );
  }
}
