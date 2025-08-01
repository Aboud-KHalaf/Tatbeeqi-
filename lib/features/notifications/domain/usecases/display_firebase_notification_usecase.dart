import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tatbeeqi/core/error/failures.dart';

import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class DisplayFirebaseNotificationUsecase {
  final NotificationsRepository repository;

  DisplayFirebaseNotificationUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({required RemoteMessage message}) async {
    return await repository.displayFirebaseNotification(message: message);
  }
}
