import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/features/courses_content/presentation/views/pdf_viewer_view.dart';
import 'package:tatbeeqi/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:tatbeeqi/features/home/presentation/widgets/recently_added_section.dart';
import 'package:tatbeeqi/features/home/presentation/widgets/study_progress_section.dart';
import 'package:tatbeeqi/features/news/presentation/widgets/news_section.dart';
import 'package:tatbeeqi/features/quiz/presentation/views/quiz_view.dart';
import 'package:tatbeeqi/features/todo/presentation/widgets/today_tasks_section.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  static const String routePath = '/homeView';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //  initDeviceToken();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // initDeviceToken(); // Re-register token if needed
    }
  }

  // Future<void> initDeviceToken() async {
  //   final user = Supabase.instance.client.auth.currentUser;
  //   if (user != null) {
  //    late String token;
  //     final tokenOrFailure = await sl<GetDeviceTokenUsecase>().call();
  //     tokenOrFailure.fold((l) => null, (r) => token = r);
  //    print(token);
  //     await sl<RegisterDeviceTokenUseCase>().call(RegisterDeviceTokenRequest(deviceToken: token, platform: 'android'));
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const CustomHomeAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
        children: [
          _SectionTitle(
            title: l10n.homeLatestNewsAndEvents,
            onPressed: () {
              context.push(AppRoutes.allNewsPath);
            },
          ),
          const SizedBox(height: 12.0),
          const NewsSection(),
          const SizedBox(height: 28.0),
          _SectionTitle(
              title: l10n.homeTodayTasks,
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QuizView(lessonId: 10)),
                );
                //context.push(AppRoutes.todoPath);
              }),
          const SizedBox(height: 12.0),
          const TodayTasksSection(),
          const SizedBox(height: 28.0),
          _SectionTitle(title: l10n.homeContinueStudying, onPressed: () {}),
          const SizedBox(height: 12.0),
          const StudyProgressSection(),
          const SizedBox(height: .0),
          _SectionTitle(title: l10n.homeRecentlyAdded, onPressed: () {}),
          const SizedBox(height: 12.0),
          const RecentlyAddedSection(),
        ],
      ),
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
