import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/utils/app_functions.dart';
import 'package:tatbeeqi/core/utils/app_methods.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/fetch_courses_cubit/fetch_courses_cubit.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/retake_courses_cubit/retake_courses_cubit.dart';
import 'course_card_header.dart';
import 'course_card_progress.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  final int index;

  const CourseCard({super.key, required this.course, required this.index});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500 + (widget.index * 80)),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLongPress() async {
    if (widget.course.semester == 3) {
      bool deleteConfirmation = await showDeleteConfirmation(context);
      if (deleteConfirmation) {
        if (mounted) {
          context
              .read<RetakeCoursesCubit>()
              .deleteRetakeCourse(widget.course.id);
          context.read<FetchCoursesCubit>().fetchCourses(1, 2);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = Theme.of(context).colorScheme.surface;
    final rawProgress = widget.course.progressPercent ?? 0;
    final progress = rawProgress.clamp(0.0, 1.0); // to avoid over 100%
    final progressText = '${(progress * 100).toInt()}%';
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: _isHovering
                  ? (Matrix4.identity()..translate(0, -5, 0))
                  : Matrix4.identity(),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.1)),
                ),
                child: InkWell(
                  onLongPress: _handleLongPress,
                  onTap: () {
                    context.push(
                      AppRoutes.courseOverviewPath,
                      extra: const Course(
                        id: 1,
                        courseCode: "courseCode",
                        courseName: "courseName",
                        departmentId: 2,
                        studyYear: 1,
                        semester: 1,
                        progressPercent: 1,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  splashColor:
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  highlightColor:
                      Theme.of(context).primaryColor.withValues(alpha: 0.05),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cardColor,
                          cardColor.withValues(alpha: 0.95),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CourseCardHeader(
                            iconData: getIconByCourseId(widget.course.id),
                            title: widget.course.courseName,
                          ),
                          const Spacer(),
                          CourseCardProgress(
                            progress: progress,
                            progressText: progressText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
