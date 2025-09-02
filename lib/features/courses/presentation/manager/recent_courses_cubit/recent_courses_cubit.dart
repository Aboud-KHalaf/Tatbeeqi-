import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/clear_recent_courses_usecase.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/get_recent_courses_usecase.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/remove_recent_course_usecase.dart';
import 'package:tatbeeqi/features/courses/domain/usecases/track_course_visit_usecase.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/recent_courses_cubit/recent_courses_state.dart';

class RecentCoursesCubit extends Cubit<RecentCoursesState> {
  final GetRecentCoursesUseCase _getRecentCourses;
  final TrackCourseVisitUseCase _trackVisit;
  final RemoveRecentCourseUseCase _removeRecent;
  final ClearRecentCoursesUseCase _clearAll;
  final GetCurrentUserUseCase _getCurrentUser;
  RecentCoursesCubit({
    required GetRecentCoursesUseCase getRecentCoursesUseCase,
    required TrackCourseVisitUseCase trackCourseVisitUseCase,
    required RemoveRecentCourseUseCase removeRecentCourseUseCase,
    required ClearRecentCoursesUseCase clearRecentCoursesUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _getRecentCourses = getRecentCoursesUseCase,
        _trackVisit = trackCourseVisitUseCase,
        _removeRecent = removeRecentCourseUseCase,
        _clearAll = clearRecentCoursesUseCase,
        _getCurrentUser = getCurrentUserUseCase,
        super(RecentCoursesInitial());

  Future<void> load({int limit = 5}) async {
    emit(RecentCoursesLoading());
    try {
      final user = await _getCurrentUser();
      print(user!.id);
      final List<Course> list = await _getRecentCourses(user.id, limit: limit);
      if (list.isEmpty) {
        emit(RecentCoursesEmpty());
      } else {
        emit(RecentCoursesLoaded(list));
      }
    } catch (e) {
      emit(RecentCoursesError(e.toString()));
    }
  }

  Future<void> track(int courseId) async {
    try {
      final user = await _getCurrentUser();
      await _trackVisit(user!.id, courseId);
      // Not reloading immediately to avoid flicker; consumers can call load when appropriate
    } catch (_) {}
  }

  Future<void> remove(int courseId) async {
    final current = state;
    try {
      final user = await _getCurrentUser();
      await _removeRecent(user!.id, courseId);
      if (current is RecentCoursesLoaded) {
        final updated = List<Course>.from(current.courses)
          ..removeWhere((c) => c.id == courseId);
        if (updated.isEmpty) {
          emit(RecentCoursesEmpty());
        } else {
          emit(RecentCoursesLoaded(updated));
        }
      } else {
        await load();
      }
    } catch (e) {
      emit(RecentCoursesError(e.toString()));
    }
  }

  Future<void> clear() async {
    try {
      final user = await _getCurrentUser();
      await _clearAll(user!.id);
      emit(RecentCoursesEmpty());
    } catch (e) {
      emit(RecentCoursesError(e.toString()));
    }
  }
}
