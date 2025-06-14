import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';

import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class CancelNotificationUsecase {
  final NotificationsRepository repository;

  CancelNotificationUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({required int id}) async {
    return await repository.cancelNotification(id: id);
  }
}
