import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/features/feedbacks/data/datasources/feedback_remote_data_source.dart';
import 'package:tatbeeqi/features/feedbacks/data/repositories/feedback_repository_impl.dart';
import 'package:tatbeeqi/features/feedbacks/domain/repositories/feedback_repository.dart';
import 'package:tatbeeqi/features/feedbacks/domain/usecases/get_user_feedbacks_usecase.dart';
import 'package:tatbeeqi/features/feedbacks/domain/usecases/submit_feedback_usecase.dart';
import 'package:tatbeeqi/features/feedbacks/presentation/manager/feedback_cubit/feedback_cubit.dart';

void initFeedbackDependencies(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<FeedbackRemoteDataSource>(
    () => FeedbackRemoteDataSourceImpl(
      supabaseClient: sl<SupabaseClient>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<FeedbackRepository>(
    () => FeedbackRepositoryImpl(
      remoteDataSource: sl<FeedbackRemoteDataSource>(),
      connectionChecker: sl<InternetConnectionChecker>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SubmitFeedbackUseCase(sl<FeedbackRepository>()));
  sl.registerLazySingleton(() => GetUserFeedbacksUseCase(sl<FeedbackRepository>()));

  // Cubit
  sl.registerFactory(
    () => FeedbackCubit(
      submitFeedbackUseCase: sl<SubmitFeedbackUseCase>(),
      getUserFeedbacksUseCase: sl<GetUserFeedbacksUseCase>(),
    ),
  );
}
