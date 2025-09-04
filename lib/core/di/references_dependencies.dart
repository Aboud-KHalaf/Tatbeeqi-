import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/network/network_info.dart';
import 'package:tatbeeqi/features/references/data/datasources/mock_references_datasource.dart';
import 'package:tatbeeqi/features/references/data/repositories/references_repository_impl.dart';
import 'package:tatbeeqi/features/references/domain/repositories/references_repository.dart';
import 'package:tatbeeqi/features/references/domain/use_cases/fetch_references_use_case.dart';
import 'package:tatbeeqi/features/references/presentation/manager/references_cubit.dart';

void initReferencesDependencies(GetIt sl) {
  // Data source
  sl.registerLazySingleton<ReferencesRemoteDataSource>(
    () => ReferencesRemoteDataSourceImpl(supabaseClient: sl<SupabaseClient>()),
  );

  // Repository
  sl.registerLazySingleton<ReferencesRepository>(
    () => ReferencesRepositoryImpl(
      dataSource: sl<ReferencesRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Use case
  sl.registerLazySingleton(() => FetchReferencesUseCase(sl<ReferencesRepository>()));

  // Cubit
  sl.registerFactory(() => ReferencesCubit(fetchReferencesUseCase: sl()));
}
