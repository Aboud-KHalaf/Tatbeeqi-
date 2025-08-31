import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/auth/presentation/manager/bloc/auth_bloc.dart';

/// Bloc observer focused on AuthBloc.
/// Logs lifecycle, events, transitions, and errors with concise labels.
class AuthObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    if (bloc is AuthBloc) {
      dev.log('[Auth] onCreate', name: 'Bloc');
    }
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    if (bloc is AuthBloc) {
      dev.log('[Auth] onClose', name: 'Bloc');
    }
    super.onClose(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    if (bloc is AuthBloc) {
      dev.log('[Auth] onEvent -> ${event.runtimeType}', name: 'Bloc');
    }
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (bloc is AuthBloc) {
      final next = _label(transition.nextState);
      final prev = _label(transition.currentState);
      dev.log('[Auth] onTransition -> $prev => $next', name: 'Bloc');
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if (bloc is AuthBloc) {
      final next = _label(change.nextState);
      final prev = _label(change.currentState);
      dev.log('[Auth] onChange -> $prev => $next', name: 'Bloc');
    }
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (bloc is AuthBloc) {
      dev.log('[Auth] onError: $error', name: 'Bloc', error: error, stackTrace: stackTrace);
    }
    super.onError(bloc, error, stackTrace);
  }

  String _label(Object state) {
    if (state is AuthInitial) return 'Initial';
    if (state is AuthLoading) return 'Loading(${state.operation.name})';
    if (state is AuthAuthenticated) return 'Authenticated(${state.user.id})';
    if (state is AuthUnauthenticated) return 'Unauthenticated';
    if (state is AuthError) return 'Error(${state.message})';
    return state.runtimeType.toString();
  }
}
