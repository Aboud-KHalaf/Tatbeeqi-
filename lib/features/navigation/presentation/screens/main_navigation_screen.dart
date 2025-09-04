import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/widgets/custom_app_bar.dart';
import 'package:tatbeeqi/features/courses/presentation/views/courses_view.dart';
import 'package:tatbeeqi/features/home/presentation/views/home_view.dart';
import 'package:tatbeeqi/features/navigation/presentation/manager/navigation_cubit/navigation_cubit.dart';
import 'package:tatbeeqi/features/navigation/presentation/manager/navigation_cubit/navigation_state.dart';
import 'package:tatbeeqi/features/navigation/presentation/widgets/material3_bottom_nav_bar.dart';
import 'package:tatbeeqi/features/posts/presentation/views/posts_feed_view.dart';
import 'package:tatbeeqi/features/more/presentation/views/more_view.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late final PageController _pageController;
  bool _isNavigatingProgrammatically = false;

  final List<Widget> _screens = const [
    HomeView(),
    CoursesView(),
    PostsFeedView(),
    MoreView(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: context.read<NavigationCubit>().state.index,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final appBarTitles = [
      l10n.homeGreeting,
      l10n.navCourses,
      l10n.navCommunity,
      l10n.navMore,
    ];

    return BlocListener<NavigationCubit, NavigationState>(
      listenWhen: (prev, curr) => prev.index != curr.index,
      listener: (context, state) {
        _isNavigatingProgrammatically = true;
        _pageController
            .animateToPage(
          state.index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        )
            .then((_) {
          _isNavigatingProgrammatically = false;
        });
      },
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(title: appBarTitles[state.index]),
            body: PageView(
              controller: _pageController,
              physics: const ClampingScrollPhysics(),
              onPageChanged: (index) {
                if (!_isNavigatingProgrammatically) {
                  context.read<NavigationCubit>().changeIndex(index);
                }
              },
              children: _screens,
            ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: state.index,
              onTap: (index) {
                context.read<NavigationCubit>().changeIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}
