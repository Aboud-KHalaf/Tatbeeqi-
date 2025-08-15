import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lecture_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lessons/lessons_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/lecture_content.dart';
import 'package:shimmer/shimmer.dart';

class LectureLessonsShimmer extends StatelessWidget {
  const LectureLessonsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    final shimmerBaseColor =
        colorScheme.onSurfaceVariant.withValues(alpha: 0.3);
    final shimmerHighlightColor = theme.scaffoldBackgroundColor;
    const placeholderColor = Colors.white;

    Widget shimmerContainer(
        {double? width, double? height, double radius = 4}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: placeholderColor,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Module progress shimmer
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerContainer(width: 120, height: 20, radius: 8),
                        const SizedBox(height: 16),
                        shimmerContainer(
                            width: double.infinity, height: 8, radius: 4),
                        const SizedBox(height: 8),
                        shimmerContainer(
                            width: screenWidth * 0.7, height: 8, radius: 4),
                        const SizedBox(height: 16),
                        shimmerContainer(
                            width: double.infinity, height: 12, radius: 6),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Up next card shimmer
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerContainer(width: 100, height: 16, radius: 8),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            shimmerContainer(width: 48, height: 48, radius: 8),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  shimmerContainer(
                                      width: 200, height: 16, radius: 4),
                                  const SizedBox(height: 8),
                                  shimmerContainer(
                                      width: 120, height: 12, radius: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Lecture description shimmer
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerContainer(width: 150, height: 20, radius: 8),
                        const SizedBox(height: 16),
                        shimmerContainer(
                            width: double.infinity, height: 12, radius: 4),
                        const SizedBox(height: 8),
                        shimmerContainer(
                            width: screenWidth * 0.9, height: 12, radius: 4),
                        const SizedBox(height: 8),
                        shimmerContainer(
                            width: screenWidth * 0.8, height: 12, radius: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Course content list shimmer
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.12)),
                    ),
                    child: Row(
                      children: [
                        shimmerContainer(width: 40, height: 40, radius: 8),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              shimmerContainer(
                                  width: 180, height: 16, radius: 4),
                              const SizedBox(height: 8),
                              shimmerContainer(
                                  width: 120, height: 12, radius: 4),
                            ],
                          ),
                        ),
                        shimmerContainer(width: 24, height: 24, radius: 12),
                      ],
                    ),
                  ),
                ),
                childCount: 5, // Number of shimmer items
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class LectureLessonsView extends StatefulWidget {
  static const String routePath = '/lectureLessonsView';
  final Course course;
  final Lecture lecture;
  const LectureLessonsView(
      {super.key, required this.course, required this.lecture});

  @override
  State<LectureLessonsView> createState() => _LectureLessonsViewState();
}

class _LectureLessonsViewState extends State<LectureLessonsView> {
  @override
  void initState() {
    super.initState();
    context.read<LessonsCubit>().fetchLessons(widget.lecture.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${widget.lecture.title}'),
      ),
      body: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          if (state is LessonsLoaded) {
            return LectureContent(
                course: widget.course,
                lessons: state.lessons,
                lecture: widget.lecture);
          }
          if (state is LessonsLoading) return const LectureLessonsShimmer();
          if (state is LessonsError) return Text(state.message);
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
