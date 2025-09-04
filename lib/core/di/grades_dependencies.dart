import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/network/network_info.dart';
import 'package:tatbeeqi/features/grades/data/datasources/grades_remote_datasource.dart';
import 'package:tatbeeqi/features/grades/data/repositories/grades_repository_impl.dart';
import 'package:tatbeeqi/features/grades/domain/repositories/grades_repository.dart';
import 'package:tatbeeqi/features/grades/domain/use_cases/fetch_grades_by_course_id_use_case.dart';
import 'package:tatbeeqi/features/grades/domain/use_cases/fetch_grades_by_lesson_and_course_id_use_case.dart';
import 'package:tatbeeqi/features/grades/domain/use_cases/insert_grade_use_case.dart';
import 'package:tatbeeqi/features/grades/domain/use_cases/update_grade_use_case.dart';
import 'package:tatbeeqi/features/grades/presentation/manager/grades_cubit.dart';

void initGradesDependencies(GetIt sl) {
  // Data source
  sl.registerLazySingleton<GradesRemoteDataSource>(
    () => GradesRemoteDataSourceImpl(sl<SupabaseClient>()),
  );

  // Repository
  sl.registerLazySingleton<GradesRepository>(
    () => GradesRepositoryImpl(
      dataSource: sl<GradesRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => FetchGradesByCourseIdUseCase(sl<GradesRepository>()));
  sl.registerLazySingleton(() => FetchGradesByLessonAndCourseIdUseCase(sl<GradesRepository>()));
  sl.registerLazySingleton(() => InsertGradeUseCase(sl<GradesRepository>()));
  sl.registerLazySingleton(() => UpdateGradeUseCase(sl<GradesRepository>()));

  // Cubit
  sl.registerFactory(() => GradesCubit(
        fetchByCourseId: sl(),
        fetchByLessonAndCourseId: sl(),
        insertGradeUseCase: sl(),
        updateGradeUseCase: sl(),
      ));
}
