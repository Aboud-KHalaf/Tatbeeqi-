import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/streaks/data/datasources/streaks_remote_datasource.dart';
import '../../features/streaks/data/repositories/streaks_repository_impl.dart';
import '../../features/streaks/domain/repositories/streaks_repository.dart';
import '../../features/streaks/domain/usecases/get_user_streak.dart';
import '../../features/streaks/domain/usecases/update_streak_on_lesson_complete.dart';
import '../../features/streaks/presentation/cubit/streaks_cubit.dart';

void initStreaksDependencies(GetIt sl) {
  // Cubit
  sl.registerFactory(
    () => StreaksCubit(
      getUserStreak: sl(),
      updateStreakOnLessonComplete: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserStreak(sl()));
  sl.registerLazySingleton(() => UpdateStreakOnLessonComplete(sl()));

  // Repository
  sl.registerLazySingleton<StreaksRepository>(
    () => StreaksRepositoryImpl(
      remoteDataSource: sl(),
      connectionChecker: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<StreaksRemoteDataSource>(
    () => StreaksRemoteDataSourceImpl(
      supabaseClient: sl<SupabaseClient>(),
    ),
  );
}
