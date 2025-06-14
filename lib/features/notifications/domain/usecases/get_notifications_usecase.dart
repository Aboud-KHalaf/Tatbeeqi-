import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';

import '../entities/app_notification.dart';
import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class GetNotificationsUsecase {
  final NotificationsRepository repository;

  GetNotificationsUsecase({required this.repository});

  Future<Either<Failure, List<AppNotification>>> call() async {
    return await repository.getNotifications();
  }
}
