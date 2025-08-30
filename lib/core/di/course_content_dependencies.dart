import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/features/courses_content/data/datasources/courses_content_remote_data_source.dart';
import 'package:tatbeeqi/features/courses_content/data/repositories/courses_content_repository_impl.dart';
import 'package:tatbeeqi/features/courses_content/domain/repository/courses_content_repository.dart';
import 'package:tatbeeqi/features/courses_content/domain/usecases/fetch_lectures_by_course_id_usecase.dart';
import 'package:tatbeeqi/features/courses_content/domain/usecases/fetch_lessons_by_lecture_id_usecase.dart';
import 'package:tatbeeqi/features/courses_content/domain/usecases/mark_lesson_as_completed_usecase.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lectures/lectures_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lesson_completion/lesson_completion_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lessons/lessons_cubit.dart';

void initCourseContentDependencies(GetIt sl) {
  // --- Courses Feature ---

  // Manager
  sl.registerFactory(() => LecturesCubit(
        fetchLecturesByCourseIdUsecase: sl(),
      ));
      

  sl.registerFactory(() => LessonsCubit(fetchLessonsByLectureIdUsecase: sl()));
  sl.registerFactory(
      () => LessonCompletionCubit(markLessonAsCompletedUsecase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => FetchLessonsByLectureIdUseCase(sl()));
  sl.registerLazySingleton(() => MarkLessonAsCompletedUseCase(sl()));
  sl.registerLazySingleton(() => FetchLecturesByCourseIdUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CoursesContentRepository>(
      () => CoursesContentRepositoryImpl(
            remoteDataSource: sl(),
          ));

  // Data Sources
  sl.registerLazySingleton<CoursesContentRemoteDataSource>(() =>
      CoursesContentRemoteDataSourceImpl(supabaseClient: sl<SupabaseClient>()));
}
