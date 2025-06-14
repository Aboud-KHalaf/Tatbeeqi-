import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';

import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class UnsubscribeToTopicUsecase {
  final NotificationsRepository repository;

  UnsubscribeToTopicUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({required String topic}) async {
    return await repository.unsubscribeToTopic(topic: topic);
  }
}
