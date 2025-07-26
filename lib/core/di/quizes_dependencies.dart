import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/quiz/data/datasources/quiz_local_data_source.dart';
import 'package:tatbeeqi/features/quiz/data/datasources/quiz_remote_data_source.dart';
import 'package:tatbeeqi/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:tatbeeqi/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:tatbeeqi/features/quiz/domain/usecases/evaluate_quiz_answers.dart';
import 'package:tatbeeqi/features/quiz/domain/usecases/get_quiz_questions.dart';
import 'package:tatbeeqi/features/quiz/presentation/bloc/quiz_bloc.dart';

void initQuizzesDependencies(GetIt sl) {
  // BLoC
  sl.registerFactory(
    () => QuizBloc(
      getQuizQuestionsUseCase: sl(),
      evaluateQuizAnswersUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetQuizQuestionsUseCase(sl()));
  sl.registerLazySingleton(() => EvaluateQuizAnswersUseCase(sl()));

  // Repository
  sl.registerLazySingleton<QuizRepository>(
      () => QuizRepositoryImpl(sl(), sl()));

  // Data sources
  sl.registerLazySingleton<QuizLocalDataSource>(
      () => QuizLocalDataSourceImpl());
  sl.registerLazySingleton<QuizRemoteDataSource>(
      () => QuizRemoteDataSourceImpl(sl()));
}
