import 'package:dartz/dartz.dart';

import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';
 
class RegisterDeviceTokenUseCase {
  final NotificationsRepository repository;

  RegisterDeviceTokenUseCase({required this.repository});

  Future<Either<Failure, Unit>> call(RegisterDeviceTokenParams request) async {
    return await repository.registerDeviceToken(
      deviceToken: request.deviceToken,
      platform: request.platform,
    );
  }
}
class RegisterDeviceTokenParams {
  final String deviceToken;
  final String platform;

  RegisterDeviceTokenParams(
      {required this.deviceToken, required this.platform});
}