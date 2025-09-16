import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';

import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class InitializeFirebaseNotificationsUsecase {
  final NotificationsRepository repository;

  InitializeFirebaseNotificationsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call() async {
    return await repository.initializeFirebaseNotifications();
  }
}
