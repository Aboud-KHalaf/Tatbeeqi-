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

class _RetakeCoursesConfirmButtonState extends State<RetakeCoursesConfirmButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 4.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

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

          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTapDown: isEnabled ? _handleTapDown : null,
                  onTapUp: isEnabled ? _handleTapUp : null,
                  onTapCancel: isEnabled ? _handleTapCancel : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: isEnabled
                          ? [
                              BoxShadow(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.3),
                                blurRadius: 8 * _elevationAnimation.value,
                                offset:
                                    Offset(0, 4 * _elevationAnimation.value),
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isEnabled
                            ? () {
                                HapticFeedback.mediumImpact();
                                context
                                    .read<RetakeCoursesCubit>()
                                    .saveRetakeCourses(selectedCoursesList);
                                context
                                    .read<FetchCoursesCubit>()
                                    .fetchCourses(1, 2);
                              }
                            : null,
                        borderRadius: BorderRadius.circular(28),
                        child: Container(
                          alignment: Alignment.center,
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
                                  children: [
                                    if (selectedCoursesList.isNotEmpty) ...[
                                      Icon(
                                        Icons.school_rounded,
                                        color: colorScheme.onPrimary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(
                                      buttonText,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        color: isEnabled
                                            ? colorScheme.onPrimary
                                            : colorScheme.onSurface
                                                .withValues(alpha: 0.38),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
