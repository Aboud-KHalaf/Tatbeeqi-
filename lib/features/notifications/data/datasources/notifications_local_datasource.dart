import 'package:dartz/dartz.dart';

import '../../domain/entities/app_notification.dart';

abstract class NotificationsLocalDatasource {
  ///
  Future<List<AppNotification>> getNotifications();

  ///
  Future<Unit> clearNotifications();

  ///
  Future<int> insertNotification({required AppNotification notification});

  ///
  Future<int> deleteNotification({required int notificationId});
}

class NotificationsLocalDatasourceImplements
    implements NotificationsLocalDatasource {

  NotificationsLocalDatasourceImplements();
  @override
  Future<int> insertNotification(
      {required AppNotification notification}) async {
 
    return 1;
  }

  @override
  Future<int> deleteNotification({required int notificationId}) async {
   
    return 1;
  }

  @override
  Future<List<AppNotification>> getNotifications() async {
   

    return [];
  }

  @override
  Future<Unit> clearNotifications() async {

    return unit;
  }
}
