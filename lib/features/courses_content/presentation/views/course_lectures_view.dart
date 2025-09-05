import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';
import 'package:tatbeeqi/core/widgets/app_error.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lecture_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/lectures/lectures_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/lecture_card.dart';
import 'package:tatbeeqi/features/courses_content/presentation/widgets/lecture_card_shimmer.dart';

class CourseLecturesView extends StatelessWidget {
  final Course course;
  static const String routePath = '/courseLecturesView';

  const CourseLecturesView({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LecturesCubit, LecturesState>(
        builder: (context, state) {
          if (state is LecturesInitial) {
            return const LectureShimmerList();
          } else if (state is LecturesLoading) {
            return const LectureShimmerList();
          } else if (state is LecturesLoaded) {
            if (state.lectures.isEmpty) {
              return _EmptyState();
            }
            return LecturesList(lectures: state.lectures, course: course);
          } else if (state is LecturesError) {
            return AppError(
              onAction: () =>
                  context.read<LecturesCubit>().fetchLectures(course.id),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class LecturesList extends StatelessWidget {
  final List<Lecture> lectures;
  final Course course;
  const LecturesList({super.key, required this.lectures, required this.course});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: lectures.length,
      itemBuilder: (context, index) {
        return LectureCard(
          lecture: lectures[index],
          onTap: () {
            context.push(
              AppRoutes.lectureLessonsPath,
              extra: LectureLessonsArgs(
                course: course,
                lecture: lectures[index],
              ),
            );
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 80,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.coursesContentNoLecturesAvailable,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
