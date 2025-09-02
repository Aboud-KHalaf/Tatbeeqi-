import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/services/database/database_service.dart';
import 'package:tatbeeqi/features/courses/data/datasources/course_local_data_source.dart';
import 'package:tatbeeqi/features/courses/data/datasources/course_remote_data_source.dart';
import 'package:tatbeeqi/features/courses/data/repositories/course_repository_impl.dart';
import 'package:tatbeeqi/features/courses/domain/repositories/course_repository.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/delete_retake_course_usecase.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/get_all_courses_for_retake_usecase.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/get_courses_by_study_year_and_department_id_usecase.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/save_selected_retake_courses_usecase.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/fetch_courses_cubit/fetch_courses_cubit.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/retake_courses_cubit/retake_courses_cubit.dart';
import 'package:tatbeeqi/features/courses/data/datasources/recent_courses_datasource.dart';
import 'package:tatbeeqi/features/courses/data/repositories/recent_courses_repository_impl.dart';
import 'package:tatbeeqi/features/courses/domain/repositories/recent_courses_repository.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/get_recent_courses_usecase.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/track_course_visit_usecase.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/clear_recent_courses_usecase.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/remove_recent_course_usecase.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/recent_courses_cubit/recent_courses_cubit.dart';

void initCoursesDependencies(GetIt sl) {
  // --- Courses Feature ---

  // Manager (Cubit)
  sl.registerFactory(() => FetchCoursesCubit(
        getCurrentUserUseCase: sl(),
        getCoursesByStudyYearUseCase: sl(),
      ));
  sl.registerFactory(() => RetakeCoursesCubit(
        getAllCoursesForRetakeUsecase: sl(),
        saveSelectedRetakeCoursesUseCase: sl(),
        deleteRetakeCourseUseCase: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(
      () => GetCoursesByStudyYearAndDepartmentIdUseCase(sl()));
  sl.registerLazySingleton(() => GetAllCoursesForRetakeUsecase(sl()));
  sl.registerLazySingleton(() => SaveSelectedRetakeCoursesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteRetakeCourseUseCase(sl()));
  // Repository
  sl.registerLazySingleton<CourseRepository>(() => CourseRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ));

  // Data Sources
  sl.registerLazySingleton<CourseRemoteDataSource>(
      () => CourseRemoteDataSourceImpl(supabaseClient: sl<SupabaseClient>()));

  sl.registerLazySingleton<CourseLocalDataSource>(
      () => CourseLocalDataSourceImpl(
            databaseService: sl<DatabaseService>(),
          ));

  // Recent Courses: Data Source
  sl.registerLazySingleton<RecentCoursesDataSource>(
      () => RecentCoursesDataSourceImpl(databaseService: sl<DatabaseService>()));

  // Recent Courses: Repository
  sl.registerLazySingleton<RecentCoursesRepository>(() =>
      RecentCoursesRepositoryImpl(dataSource: sl(), courseLocal: sl()));

  // Recent Courses: Use Cases
  sl.registerLazySingleton(() => GetRecentCoursesUseCase(sl()));
  sl.registerLazySingleton(() => TrackCourseVisitUseCase(sl()));
  sl.registerLazySingleton(() => ClearRecentCoursesUseCase(sl()));
  sl.registerLazySingleton(() => RemoveRecentCourseUseCase(sl()));

  // Recent Courses: Cubit
  sl.registerFactory(() => RecentCoursesCubit(
        getRecentCoursesUseCase: sl(),
        trackCourseVisitUseCase: sl(),
        removeRecentCourseUseCase: sl(),
        clearRecentCoursesUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ));
}
