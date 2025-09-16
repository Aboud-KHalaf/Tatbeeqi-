import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';
import 'package:tatbeeqi/features/notifications/data/datasources/notifications_local_datasource.dart';
import 'package:tatbeeqi/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:tatbeeqi/features/notifications/data/models/app_notification_model.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/app_notification.dart';
import 'package:tatbeeqi/features/notifications/domain/entities/reminder.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImplements implements NotificationsRepository {
  final NotificationsRemoteDatasource _remoteDatasource;
  final NotificationsLocalDatasource _localDatasource;

  NotificationsRepositoryImplements(
      this._localDatasource, this._remoteDatasource);

  /// ------------------ Helper ------------------
  Future<Either<Failure, T>> _safeCall<T>(Future<T> Function() call,
      {String? logTag}) async {
    try {
      final result = await call();
      return right(result);
    } on Exception catch (e) {
      if (logTag != null) AppLogger.error('$logTag error: $e');
      return left(ServerFailure(e.toString()));
    }
  }

  /// ------------------ Initialization ------------------
  @override
  Future<Either<Failure, Unit>> initializeLocalNotifications() =>
      _safeCall(() => _localDatasource.initializeLocalNotifications(),
          logTag: 'initializeLocalNotifications');

  @override
  Future<Either<Failure, Unit>> initializeFirebaseNotifications() =>
      _safeCall(() => _remoteDatasource.initializeFirebaseNotifications(),
          logTag: 'initializeFirebaseNotifications');

  @override
  Future<Either<Failure, Unit>> createNotificationChannel(
          {required AndroidNotificationChannel channel}) =>
      _safeCall(() async {
        await _localDatasource.createNotificationChannel(channel);
        debugPrint("createNotificationChannel success");
        return unit;
      });

  /// ------------------ Device Token Management ------------------
  @override
  Future<Either<Failure, String>> getDeviceToken() =>
      _safeCall(() => _remoteDatasource.getDeviceToken(),
          logTag: 'getDeviceToken');

  @override
  Future<Either<Failure, String>> refreshDeviceToken() async {
    await FirebaseMessaging.instance.deleteToken();
    return getDeviceToken();
  }

  @override
  Future<Either<Failure, Unit>> deleteDeviceToken() =>
      _safeCall(() => _remoteDatasource.deleteDeviceToken(),
          logTag: 'deleteDeviceToken');

  @override
  Future<Either<Failure, Unit>> registerDeviceToken(
          {required String deviceToken, required String platform}) =>
      _safeCall(
          () => _remoteDatasource.registerDeviceToken(
              deviceToken: deviceToken, platform: platform),
          logTag: 'registerDeviceToken');

  /// ------------------ Topic Subscription ------------------
  @override
  Future<Either<Failure, Unit>> subscribeToTopic({required String topic}) =>
      _safeCall(() => _remoteDatasource.subscribeToTopic(topic),
          logTag: 'subscribeToTopic');

  @override
  Future<Either<Failure, Unit>> unsubscribeFromTopic({required String topic}) =>
      _safeCall(() => _remoteDatasource.unsubscribeFromTopic(topic),
          logTag: 'unsubscribeFromTopic');

  /// ------------------ Notifications Management ------------------
  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() =>
      _safeCall(() => _remoteDatasource.getNotifications(),
          logTag: 'getNotifications');

  @override
  Future<Either<Failure, Unit>> clearNotifications() =>
      _safeCall(() => _localDatasource.clearNotifications(),
          logTag: 'clearNotifications');

  @override
  Future<Either<Failure, Unit>> displayNotification({
    required AppNotification notification,
    bool oneTimeNotification = true,
    NotificationDetails? details,
  }) =>
      _safeCall(() async {
        await _localDatasource.showLocalNotification(
          notification: AppNotificationModel.fromEntity(notification),
          oneTimeNotification: oneTimeNotification,
          details: details,
        );
        await _localDatasource.insertNotification(notification: notification);
        return unit;
      }, logTag: 'displayNotification');

  @override
  Future<Either<Failure, Unit>> displayFirebaseNotification(
          {required RemoteMessage message}) =>
      _safeCall(() async {
        await _remoteDatasource.showFirebaseNotification(message);
        await _localDatasource.insertNotification(
            notification: AppNotificationModel.fromRemoteFCM(message));
        return unit;
      }, logTag: 'displayFirebaseNotification');

  @override
  Future<Either<Failure, Unit>> deleteNotification(
          {required int notificationId}) =>
      _safeCall(() async {
        await _localDatasource.deleteNotification(
            notificationId: notificationId);
        debugPrint("deleteNotification success");
        return unit;
      }, logTag: 'deleteNotification');

  @override
  Future<Either<Failure, Unit>> cancelNotification({required int id}) =>
      _safeCall(() => _localDatasource.cancelNotification(id),
          logTag: 'cancelNotification');

  /// ------------------ Sending Notifications ------------------
  @override
  Future<Either<Failure, Unit>> sendNotificationToTopics({
    required AppNotification notification,
    required List<String> topics,
  }) =>
      _safeCall(
          () => _remoteDatasource.sendNotificationToTopics(
              notification: AppNotificationModel.fromEntity(notification),
              topics: topics),
          logTag: 'sendNotificationToTopics');

  @override
  Future<Either<Failure, Unit>> sendNotificationToUsers({
    required AppNotification notification,
    required List<String> userIds,
  }) =>
      _safeCall(
          () => _remoteDatasource.sendNotificationToUsers(
              notification: AppNotificationModel.fromEntity(notification),
              userIds: userIds),
          logTag: 'sendNotificationToUsers');

  /// ------------------ Reminders Management ------------------
  @override
  Future<void> scheduleReminder(Reminder reminder) async {
    try {
      await _localDatasource.scheduleReminder(reminder);
    } catch (e) {
      AppLogger.error('scheduleReminder error: $e');
      rethrow;
    }
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    try {
      await _localDatasource.cancelReminder(reminderId);
    } catch (e) {
      AppLogger.error('cancelReminder error: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    try {
      await _localDatasource.updateReminder(reminder);
    } catch (e) {
      AppLogger.error('updateReminder error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Reminder>> getReminders({String? courseId}) async {
    try {
      return await _localDatasource.getReminders(courseId: courseId);
    } catch (e) {
      AppLogger.error('getReminders error: $e');
      rethrow;
    }
  }
}
