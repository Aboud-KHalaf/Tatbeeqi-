import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/utils/app_logger.dart';

import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth_state_changes_usecase.dart';
import '../../../domain/usecases/forget_password_usecase.dart';
import '../../../domain/usecases/sign_in_usecase.dart';
import '../../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../../domain/usecases/sign_out_usecase.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
import '../../../domain/usecases/update_user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase _signUp;
  final SignInUseCase _signIn;
  final SignInWithGoogleUseCase _google;
  final ForgetPasswordUseCase _forgetPassword;
  final UpdateUserUseCase _updateUser;
  final SignOutUseCase _signOut;
  final AuthStateChangesUseCase _authStateChanges;
  StreamSubscription<User?>? _authSub;

  AuthBloc({
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
    required SignInWithGoogleUseCase signInWithGoogleUseCase,
    required ForgetPasswordUseCase forgetPasswordUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required SignOutUseCase signOutUseCase,
    required AuthStateChangesUseCase authStateChangesUseCase,
  })  : _signUp = signUpUseCase,
        _signIn = signInUseCase,
        _google = signInWithGoogleUseCase,
        _forgetPassword = forgetPasswordUseCase,
        _updateUser = updateUserUseCase,
        _signOut = signOutUseCase,
        _authStateChanges = authStateChangesUseCase,
        super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<SignInWithGoogleEvent>(_onGoogle);
    on<ForgetPasswordEvent>(_onForget);
    on<UpdateUserEvent>(_onUpdate);
    on<SignOutEvent>(_onSignOut);
    on<AuthStateChangedEvent>(_onAuthChanged);

    _authSub = _authStateChanges().listen((user) {
      add(AuthStateChangedEvent(user));
    });
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _signUp(
        name: event.name,
        studyYear: event.studyYear,
        department: event.department,
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      AppLogger.error("auth erro :${e.toString()}");
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _signIn(email: event.email, password: event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _google();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onForget(
      ForgetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _forgetPassword(email: event.email);
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _updateUser(
        name: event.name,
        studyYear: event.studyYear,
        department: event.department,
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _signOut();
    emit(AuthUnauthenticated());
  }

  void _onAuthChanged(AuthStateChangedEvent event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
