import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/widgets/app_error.dart';
import 'package:tatbeeqi/core/widgets/app_loading.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/retake_courses_cubit/retake_courses_cubit.dart';
import 'retake_course_card.dart'; // Import the new card widget

class RetakeCoursesContent extends StatefulWidget {
  final ValueNotifier<List<Course>> selectedCoursesNotifier;

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
          return const AppLoading();
        }

        if (state is CoursesRetakeError) {
          return const AppError();
        }

        if (state is CoursesRetakeLoaded) {
          final courses = state.courseEntities;
          if (courses.isEmpty) {
            return SizedBox(
              height: 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.school_outlined,
                        size: 48,
                        color: theme.colorScheme.primary.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'لا يوجد مقررات متاحة حالياً',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
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
              SearchBar(
                controller: _searchController,
                hintText: 'بحث عن مقررات...',
                leading: const Icon(Icons.search_rounded),
                trailing: _searchQuery.isNotEmpty
                    ? [
                        IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ),
                      ]
                    : null,
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredCourses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final course = filteredCourses[index];
                    return ValueListenableBuilder<List<Course>>(
                      valueListenable: widget.selectedCoursesNotifier,
                      builder: (_, selectedCourses, __) {
                        final isSelected =
                            selectedCourses.any((c) => c.id == course.id);
                        return RetakeCourseCard(
                          course: course,
                          isSelected: isSelected,
                          onChanged: (selected) {
                            final updated = List<Course>.from(selectedCourses);
                            if (selected) {
                              updated.add(course);
                            } else {
                              updated.removeWhere((c) => c.id == course.id);
                            }
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
