import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/retake_courses_cubit/retake_courses_cubit.dart';
import 'retake_course_card.dart'; // Import the new card widget

class RetakeCoursesContent extends StatefulWidget {
  final ValueNotifier<List<CourseEntity>> selectedCoursesNotifier;

  const RetakeCoursesContent(
      {super.key, required this.selectedCoursesNotifier});

  @override
  State<RetakeCoursesContent> createState() => _RetakeCoursesContentState();
}

class _RetakeCoursesContentState extends State<RetakeCoursesContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<RetakeCoursesCubit, RetakeCoursesState>(
      builder: (context, state) {
        if (state is CoursesRetakeLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is CoursesRetakeError) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      color: theme.colorScheme.error, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${state.message}',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (state is CoursesRetakeLoaded) {
          final courses = state.courseEntities;
          if (courses.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: Text('No courses available for retake.',
                    style: TextStyle(fontSize: 16)),
              ),
            );
          }

          final filteredCourses = courses
              .where((course) => course.courseName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();

          return Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search courses...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filteredCourses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    return ValueListenableBuilder<List<CourseEntity>>(
                      valueListenable: widget.selectedCoursesNotifier,
                      builder: (_, selectedCourses, __) {
                        final isSelected =
                            selectedCourses.any((c) => c.id == course.id);
                        return RetakeCourseCard(
                          course: course,
                          isSelected: isSelected,
                          onChanged: (selected) {
                            final updated =
                                List<CourseEntity>.from(selectedCourses);
                            selected
                                ? updated.add(course)
                                : updated.removeWhere((c) => c.id == course.id);
                            widget.selectedCoursesNotifier.value = updated;
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
