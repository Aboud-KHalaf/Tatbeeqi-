import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';

import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class InitializeLocalNotificationsUsecase {
  final NotificationsRepository repository;

  InitializeLocalNotificationsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.initializeLocalNotifications();
  }
}
