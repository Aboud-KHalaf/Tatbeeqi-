import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses_details.dart/domain/use_cases/fetch_course_details_use_case.dart';
import 'package:tatbeeqi/features/courses_details.dart/presentation/manager/course_details_state.dart';

class CourseDetailsCubit extends Cubit<CourseDetailsState> {
  final FetchCourseDetailsUseCase fetchCourseDetailsUseCase;

  CourseDetailsCubit({
    required this.fetchCourseDetailsUseCase,
  }) : super(CourseDetailsInitial());

  Future<void> fetchCourseDetails(int courseId) async {
    try {
      emit(CourseDetailsLoading());
      final courseDetails = await fetchCourseDetailsUseCase(courseId);
      emit(CourseDetailsSuccess(courseDetails));
    } catch (e) {
      emit(CourseDetailsError(e.toString()));
    }
  }
}
