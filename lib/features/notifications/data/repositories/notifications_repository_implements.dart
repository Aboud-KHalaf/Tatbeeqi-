import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
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
  // ignore: unused_field
  final NotificationsLocalDatasource _localDatasource;

  NotificationsRepositoryImplements(
      this._localDatasource, this._remoteDatasource);
  @override
  Future<Either<Failure, Unit>> initializeLocalNotification() async {
    try {
      final response = await _remoteDatasource.initializeLocalNotification();
      return right(response);
    } on Exception catch (e) {
      AppLogger.error("from repo local :  ${e.toString()} ");
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> initializeFirebaseNotification() async {
    try {
      final response = await _remoteDatasource.initializeFirebaseNotification();
      return right(response);
    } on Exception catch (e) {
      AppLogger.error("from repo FCM :  ${e.toString()} ");
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelNotification({required int id}) async {
    try {
      final response = await _remoteDatasource.cancelNotification(id);
      return right(response);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createNotificationsChannel(
      {required AndroidNotificationChannel channel}) async {
    try {
      final response =
          await _remoteDatasource.createNotificationsChannel(channel);
      debugPrint("createNotificationsChannel : $response");

      return right(unit);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> displayFirebaseNotification(
      {required RemoteMessage message}) async {
    try {
      final response1 =
          await _remoteDatasource.displayFirebaseNotification(message);
      await _localDatasource.insertNotification(
        notification: AppNotificationModel.fromRemoteFCM(message),
      );
      return right(response1);
    } on Exception catch (e) {
      debugPrint("debugging error ${e.toString()}");
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> displayNotification({
    required AppNotification notification,
    bool oneTimeNotification = true,
    NotificationDetails? details,
  }) async {
    try {
      final response = await _remoteDatasource.displayLocalNotification(
        notification: notification,
        oneTimeNotification: oneTimeNotification,
        details: details,
      );
      // Cache locally
      await _localDatasource.insertNotification(
        notification: notification,
      );
      return right(response);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() async {
    try {
      final response = await _remoteDatasource.getNotifications();
      return right(response);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearNotifications() async {
    try {
      final response = await _localDatasource.clearNotifications();
      return right(response);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(
      {required int notificationId}) async {
    try {
      final response = await _localDatasource.deleteNotification(
          notificationId: notificationId);
      debugPrint("deleteNotification : $response");
      return right(unit);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> subscribeToTopic(
      {required String topic}) async {
    try {
      await _remoteDatasource.subscribeToTopic(topic);
      return right(unit);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDeviceToken() async {
    try {
      await _remoteDatasource.deleteDeviceToken();
      return right(unit);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> unsubscribeToTopic(
      {required String topic}) async {
    try {
      await _remoteDatasource.unsubscribeToTopic(topic);
      return right(unit);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getDeviceToken() async {
    try {
      final response = await _remoteDatasource.getDeviceToken();
      return right(response);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refreshDeviceToken() async {
    await FirebaseMessaging.instance.deleteToken();
    return getDeviceToken();
  }

  @override
  Future<Either<Failure, Unit>> registerDeviceToken({
    required String deviceToken,
    required String platform,
  }) async {
    try {
      final response = await _remoteDatasource.registerDeviceToken(
        deviceToken: deviceToken,
        platform: platform,
      );
      debugPrint("Success");
      return right(response);
    } on ServerException catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendNotificationByTopics({
    required AppNotification notification,
    required List<String> topics,
  }) async {
    try {
      final response = await _remoteDatasource.sendNotificationToTopics(
          notification: notification, topics: topics);
      return right(response);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendNotificationByUsers({
    required AppNotification notification,
    required List<String> userIds,
  }) async {
    try {
      final response = await _remoteDatasource.sendNotificationToUsers(
          notification: notification, userIds: userIds);
      return right(response);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return left(ServerFailure(e.toString()));
    }
  }

  // Reminder methods implementation
  @override
  Future<void> scheduleReminder(Reminder reminder) async {
    try {
      await _localDatasource.scheduleReminder(reminder);
    } catch (e) {
      AppLogger.error('scheduleReminder repository error: $e');
      rethrow;
    }
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    try {
      await _localDatasource.cancelReminder(reminderId);
    } catch (e) {
      AppLogger.error('cancelReminder repository error: $e');
      rethrow;
    }
  }

  @override
  Future<List<Reminder>> getReminders({String? courseId}) async {
    try {
      return await _localDatasource.getReminders(courseId: courseId);
    } catch (e) {
      AppLogger.error('getReminders repository error: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    try {
      await _localDatasource.updateReminder(reminder);
    } catch (e) {
      AppLogger.error('updateReminder repository error: $e');
      rethrow;
    }
  }
}
