import 'package:dartz/dartz.dart';

import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/app_notification.dart';
import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class SendNotificationByUsersUsecase {
  final NotificationsRepository repository;
  SendNotificationByUsersUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required AppNotification notification,
    required List<String> userIds,
  }) async {
    return repository.sendNotificationToUsers(
      notification: notification,
      userIds: userIds,
    );
  }
}
