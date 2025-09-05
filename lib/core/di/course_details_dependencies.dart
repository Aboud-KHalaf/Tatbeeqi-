import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/network/network_info.dart';
import 'package:tatbeeqi/features/courses_details.dart/data/datasources/course_details_remote_datasource.dart';
import 'package:tatbeeqi/features/courses_details.dart/data/repository/course_details_repository_impl.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/repository/course_details_repository.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/use_cases/fetch_course_details_use_case.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/manager/course_details_cubit.dart';

void initCourseDetailsDependencies(GetIt sl) {
  // Data source
  sl.registerLazySingleton<CourseDetailsRemoteDataSource>(
    () => CourseDetailsRemoteDataSourceImpl(sl<SupabaseClient>()),
  );

  // Repository
  sl.registerLazySingleton<CourseDetailsRepository>(
    () => CourseDetailsRepositoryImpl(
      remoteDataSource: sl<CourseDetailsRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => FetchCourseDetailsUseCase(sl<CourseDetailsRepository>()));

  // Cubit
  sl.registerFactory(() => CourseDetailsCubit(
        fetchCourseDetailsUseCase: sl(),
      ));
}
