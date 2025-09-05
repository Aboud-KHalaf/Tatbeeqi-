import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/reports/data/datasources/reports_remote_datasource.dart';
import 'package:tatbeeqi/features/reports/data/repositories/report_repository_impl.dart';
import 'package:tatbeeqi/features/reports/domain/repositories/report_repository.dart';
import 'package:tatbeeqi/features/reports/domain/usecases/add_report_usecase.dart';
import 'package:tatbeeqi/features/reports/domain/usecases/get_my_reports_usecase.dart';
import 'package:tatbeeqi/features/reports/presentation/manager/reports_cubit.dart';

void initReportsDependencies(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<ReportsRemoteDataSource>(
    () => ReportsRemoteDataSourceImpl(
      supabaseClient: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddReportUseCase(sl()));
  sl.registerLazySingleton(() => GetMyReportsUseCase(sl()));

  // Presentation (Cubit)
  sl.registerFactory(
    () => ReportsCubit(
      addReportUseCase: sl(),
      getMyReportsUseCase: sl(),
    ),
  );
}
