import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/initialize_firebase_notifications_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/initialize_local_notifications_usecase.dart';

part 'initialize_notifications_state.dart';

class InitializeNotificationsCubit extends Cubit<InitializeNotificationsState> {
  final InitializeLocalNotificationsUsecase _initializeLocalNotifications;
  final InitializeFirebaseNotificationsUsecase _initializeFirebaseNotifications;

  InitializeNotificationsCubit({
    required InitializeLocalNotificationsUsecase initializeLocalNotifications,
    required InitializeFirebaseNotificationsUsecase
        initializeFirebaseNotifications,
  })  : _initializeLocalNotifications = initializeLocalNotifications,
        _initializeFirebaseNotifications = initializeFirebaseNotifications,
        super(InitializeNotificationsInitial());

  Future<void> initialize() async {
    print("initialize  ----------==================");
    AppLogger.warning("FCM CUBIT");
    emit(InitializeNotificationsLoading());
    final localResult = await _initializeLocalNotifications.call();
    if (localResult.isLeft()) {
      AppLogger.warning("local error");
      final failure = localResult.fold((f) => f, (_) => null);
      emit(InitializeNotificationsFailure(failure!.message));
    }
    final firebaseResult = await _initializeFirebaseNotifications.call();
    if (firebaseResult.isLeft()) {
      final failure = firebaseResult.fold((f) => f, (_) => null);
      emit(InitializeNotificationsFailure(failure!.message));
      return;
    }
    emit(InitializeNotificationsSuccess());
  }
}
