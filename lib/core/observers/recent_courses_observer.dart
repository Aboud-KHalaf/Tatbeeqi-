import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/recent_courses_cubit/recent_courses_cubit.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/recent_courses_cubit/recent_courses_state.dart';

/// Bloc observer that focuses on RecentCoursesCubit only.
/// It logs create/close and state changes with concise output.
class RecentCoursesObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    if (bloc is RecentCoursesCubit) {
      dev.log('[RecentCourses] onCreate', name: 'Bloc');
    }
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    if (bloc is RecentCoursesCubit) {
      dev.log('[RecentCourses] onClose', name: 'Bloc');
    }
    super.onClose(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    if (bloc is RecentCoursesCubit) {
      final next = change.nextState;
      final prev = change.currentState;
      dev.log(
        '[RecentCourses] onChange -> ${_label(prev)} => ${_label(next)}',
        name: 'Bloc',
      );
    }
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (bloc is RecentCoursesCubit) {
      dev.log('[RecentCourses] onError: $error', name: 'Bloc', error: error, stackTrace: stackTrace);
    }
    super.onError(bloc, error, stackTrace);
  }

  String _label(Object state) {
    if (state is RecentCoursesInitial) return 'Initial';
    if (state is RecentCoursesLoading) return 'Loading';
    if (state is RecentCoursesLoaded) return 'Loaded(${state.courses.length})';
    if (state is RecentCoursesEmpty) return 'Empty';
    if (state is RecentCoursesError) return 'Error(${state.message})';
    return state.runtimeType.toString();
  }
}
