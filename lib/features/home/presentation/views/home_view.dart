import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/constants/constants.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/features/home/presentation/widgets/recently_added_section.dart';
import 'package:tatbeeqi/features/home/presentation/widgets/study_progress_section.dart';
import 'package:tatbeeqi/features/news/presentation/widgets/news_section.dart';
import 'package:tatbeeqi/features/todo/presentation/widgets/today_tasks_section.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import 'package:tatbeeqi/core/widgets/animations/staggered_fade_slide.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: AppDimensConstants.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StaggeredFadeSlide(
                  delay: const Duration(milliseconds: 0),
                  child: _SectionTitle(
                    title: l10n.homeLatestNewsAndEvents,
                    onPressed: () => context.push(AppRoutes.allNews),
                  ),
                ),
                const SizedBox(height: 12.0),
                const StaggeredFadeSlide(
                  delay: Duration(milliseconds: 100),
                  child: NewsSection(),
                ),
                const SizedBox(height: 28.0),
                StaggeredFadeSlide(
                  delay: const Duration(milliseconds: 200),
                  child: _SectionTitle(
                      title: l10n.homeTodayTasks,
                      onPressed: () async {
                        context.push(AppRoutes.todo);
                      }),
                ),
                const SizedBox(height: 12.0),
                const StaggeredFadeSlide(
                  delay: Duration(milliseconds: 300),
                  child: TodayTasksSection(),
                ),
                const SizedBox(height: 28.0),
                StaggeredFadeSlide(
                  delay: const Duration(milliseconds: 400),
                  child: _SectionTitle(
                    title: l10n.homeContinueStudying,
                    onPressed: () => context.push(AppRoutes.allCourses),
                  ),
                ),
                const SizedBox(height: 12.0),
                const StaggeredFadeSlide(
                  delay: Duration(milliseconds: 500),
                  child: StudyProgressSection(),
                ),
                const SizedBox(height: .0),
                StaggeredFadeSlide(
                  delay: const Duration(milliseconds: 600),
                  child: _SectionTitle(
                    title: l10n.homeRecentlyAdded,
                    onPressed: () => context.push(AppRoutes.allLessons),
                  ),
                ),
                const SizedBox(height: 12.0),
                const StaggeredFadeSlide(
                  delay: Duration(milliseconds: 700),
                  child: RecentlyAddedSection(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  const _SectionTitle({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              l10n.seeAll,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
