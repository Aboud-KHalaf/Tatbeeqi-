import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';

import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class DeleteNotificationUsecase {
  final NotificationsRepository repository;

  DeleteNotificationUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({required int notificationId}) async {
    return await repository.deleteNotification(notificationId: notificationId);
  }
}
