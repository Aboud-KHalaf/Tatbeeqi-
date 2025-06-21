import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';

import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';

class GetDeviceTokenUsecase {
  final NotificationsRepository repository;

  GetDeviceTokenUsecase({required this.repository});

  Future<Either<Failure, String>> call() async {
    return await repository.getDeviceToken();
  }

  void fold(Null Function(dynamic l) param0, Function(dynamic r) param1) {}
}
