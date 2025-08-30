import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/fetch_courses_cubit/fetch_courses_cubit.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/retake_courses_cubit/retake_courses_cubit.dart';

class RetakeCoursesConfirmButton extends StatefulWidget {
  final ValueNotifier<List<Course>> selectedCoursesNotifier;
  const RetakeCoursesConfirmButton({
    super.key,
    required this.selectedCoursesNotifier,
  });

  @override
  State<RetakeCoursesConfirmButton> createState() =>
      _RetakeCoursesConfirmButtonState();
}

class _RetakeCoursesConfirmButtonState extends State<RetakeCoursesConfirmButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<RetakeCoursesCubit, RetakeCoursesState>(
      listener: (context, state) {
        if (state is RetakeCoursesSaving) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
          if (state is RetakeCoursesSaved) {
            HapticFeedback.lightImpact();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Courses saved successfully!',
                  style: TextStyle(color: colorScheme.onInverseSurface),
                ),
                backgroundColor: colorScheme.inverseSurface,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else if (state is RetakeCoursesSaveError) {
            HapticFeedback.heavyImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: ${state.message}',
                  style: TextStyle(color: colorScheme.onErrorContainer),
                ),
                backgroundColor: colorScheme.errorContainer,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        }
      },
      child: ValueListenableBuilder<List<Course>>(
        valueListenable: widget.selectedCoursesNotifier,
        builder: (_, selectedCoursesList, __) {
          final isEnabled = selectedCoursesList.isNotEmpty && !_isLoading;
          final buttonText = selectedCoursesList.isEmpty
              ? 'Select courses to retake'
              : 'اعادة ${selectedCoursesList.length} مقررات${selectedCoursesList.length == 1 ? '' : ''}';

          return SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: isEnabled
                  ? () {
                      HapticFeedback.mediumImpact();
                      context.read<RetakeCoursesCubit>().saveRetakeCourses(selectedCoursesList);
                      context.read<FetchCoursesCubit>().fetchCourses(1, 2);
                    }
                  : null,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (selectedCoursesList.isNotEmpty) ...[
                          Icon(Icons.school_rounded, color: colorScheme.onPrimary, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          buttonText,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
