import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/notifications/data/datasources/notifications_local_datasource.dart';
import 'package:tatbeeqi/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:tatbeeqi/features/notifications/data/repositories/notifications_repository_implements.dart';
import 'package:tatbeeqi/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/clear_notifications_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/delete_notification_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/get_device_token_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/initialize_firebase_notifications_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/initialize_local_notifications_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/register_device_token_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/send_notification_by_topics_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/send_notification_by_users_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/subscribe_to_topic_usecase.dart';
import 'package:tatbeeqi/features/notifications/domain/usecases/unsubscribe_to_topic_usecase.dart';

import 'package:tatbeeqi/features/notifications/presentation/manager/initialize_notifications_cubit/initialize_notifications_cubit.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/notification_settings_bloc/notification_settings_bloc.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/notifications_bloc/notifications_bloc.dart';
import 'package:tatbeeqi/features/notifications/presentation/manager/send_notification_bloc/send_notification_bloc.dart';

void initNotificationDependencies(GetIt sl) {
  // Blocs
  sl.registerFactory(() => InitializeNotificationsCubit(
        initializeLocalNotifications: sl(),
        initializeFirebaseNotifications: sl(),
      ));
  sl.registerLazySingleton(() => NotificationSettingsBloc(
        getDeviceToken: sl(),
        subscribeToTopic: sl(),
        unsubscribeFromTopic: sl(),
      ));

  sl.registerLazySingleton(() => SendNotificationBloc(
        sendNotificationByUsersUsecase: sl(),
        sendNotificationByTopicsUsecase: sl(),
      ));

  sl.registerLazySingleton(() => NotificationsBloc(
        getNotificationsUsecase: sl(),
        clearNotificationsUsecase: sl(),
        deleteNotificationUsecase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetNotificationsUsecase(repository: sl()));
  sl.registerLazySingleton(() => ClearNotificationsUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteNotificationUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => SendNotificationByUsersUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => SendNotificationByTopicsUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => InitializeLocalNotificationsUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => InitializeFirebaseNotificationsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetDeviceTokenUsecase(repository: sl()));
  sl.registerLazySingleton(() => SubscribeToTopicUsecase(repository: sl()));
  sl.registerLazySingleton(() => UnsubscribeToTopicUsecase(repository: sl()));
  sl.registerLazySingleton(() => RegisterDeviceTokenUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImplements(sl(), sl()));

  // Data sources
  sl.registerLazySingleton<NotificationsRemoteDatasource>(() =>
      NotificationsRemoteDatasourceImpl(
          supabaseClient: sl(),
          firebaseMessaging: sl(),
          localNotificationsPlugin: sl()));

  sl.registerLazySingleton<NotificationsLocalDatasource>(
      () => NotificationsLocalDatasourceImplements());
}

