import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/datasources/remote_auth_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_state_changes_usecase.dart';
import '../../features/auth/domain/usecases/forget_password_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/update_user_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

void initAuthDependencies(GetIt sl) {
  // --- Auth Feature ---

  // Bloc
  sl.registerFactory(() => AuthBloc(
        signUpUseCase: sl(),
        signInUseCase: sl(),
        signInWithGoogleUseCase: sl(),
        forgetPasswordUseCase: sl(),
        updateUserUseCase: sl(),
        signOutUseCase: sl(),
        authStateChangesUseCase: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => ForgetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => AuthStateChangesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: sl()));

  // Data Sources
  sl.registerLazySingleton<RemoteAuthDataSource>(
      () => RemoteAuthDataSourceImpl(supabaseClient: sl<SupabaseClient>()));
}
