import 'package:flutter_bloc/flutter_bloc.dart';

/// A composite BlocObserver that forwards all callbacks to a list of observers.
class MultiBlocObserver extends BlocObserver {
  MultiBlocObserver(this._observers);

  final List<BlocObserver> _observers;

  @override
  void onCreate(BlocBase bloc) {
    for (final o in _observers) {
      o.onCreate(bloc);
    }
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    for (final o in _observers) {
      o.onClose(bloc);
    }
    super.onClose(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    for (final o in _observers) {
      o.onEvent(bloc, event);
    }
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    for (final o in _observers) {
      o.onChange(bloc, change);
    }
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    for (final o in _observers) {
      o.onTransition(bloc, transition);
    }
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    for (final o in _observers) {
      o.onError(bloc, error, stackTrace);
    }
    super.onError(bloc, error, stackTrace);
  }
}
