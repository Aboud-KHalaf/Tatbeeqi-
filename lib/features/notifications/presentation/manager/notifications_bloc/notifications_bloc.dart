import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/app_notification.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/clear_notifications_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/get_notifications_usecase.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotificationsUsecase _getNotificationsUsecase;
  final ClearNotificationsUsecase _clearNotificationsUsecase;
  final DeleteNotificationUsecase _deleteNotificationUsecase;

  NotificationsBloc({
    required GetNotificationsUsecase getNotificationsUsecase,
    required ClearNotificationsUsecase clearNotificationsUsecase,
    required DeleteNotificationUsecase deleteNotificationUsecase,
  })  : _getNotificationsUsecase = getNotificationsUsecase,
        _clearNotificationsUsecase = clearNotificationsUsecase,
        _deleteNotificationUsecase = deleteNotificationUsecase,
        super(NotificationsInitial()) {
    on<GetNotifications>(_onGetNotifications);
    on<ClearNotifications>(_onClearNotifications);
    on<DeleteNotification>(_onDeleteNotification);
  }

  Future<void> _onGetNotifications(
    GetNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());
    final result = await _getNotificationsUsecase();
    result.fold(
      (failure) => emit(NotificationsFailure(failure.message)),
      (notifications) => emit(NotificationsLoaded(notifications)),
    );
  }

  Future<void> _onClearNotifications(
    ClearNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _clearNotificationsUsecase();
    result.fold(
      (failure) => emit(NotificationsFailure(failure.message)),
      (_) => emit(const NotificationsLoaded([])),
    );
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _deleteNotificationUsecase(notificationId: event.id);
    result.fold(
      (failure) => emit(NotificationsFailure(failure.message)),
      (_) {
        if (state is NotificationsLoaded) {
          final currentState = state as NotificationsLoaded;
          final updatedNotifications = currentState.notifications
              .where((notification) => notification.id != event.id)
              .toList();
          emit(NotificationsLoaded(updatedNotifications));
        }
      },
    );
  }
}
