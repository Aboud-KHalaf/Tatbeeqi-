import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/courses/presentation/views/courses_view.dart';
import 'package:tatbeeqi/features/home/presentation/views/home_view.dart';
import 'package:tatbeeqi/features/navigation/presentation/manager/navigation_cubit/navigation_cubit.dart';
import 'package:tatbeeqi/features/navigation/presentation/manager/navigation_cubit/navigation_state.dart';
import 'package:tatbeeqi/features/navigation/presentation/widgets/material3_bottom_nav_bar.dart';
import 'package:tatbeeqi/features/posts/presentation/views/posts_feed_view.dart';
import 'package:tatbeeqi/features/settings/presentation/screens/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late final PageController _pageController;
  bool _isNavigatingProgrammatically = false;

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

  final List<Widget> _screens = const [
    HomeView(),
    CoursesView(),
    PostsFeedView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        backgroundColor: Colors.red,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            // Only update cubit if user swiped (not programmatic navigation)
            if (!_isNavigatingProgrammatically) {
              context.read<NavigationCubit>().changeIndex(index);
            }
          },
          physics: const ClampingScrollPhysics(),
          children: _screens,
        ),
        bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return BottomNavBar(
              currentIndex: state.index,
              onTap: (index) {
                HapticFeedback.selectionClick();
                context.read<NavigationCubit>().changeIndex(index);
              },
            );
          },
        ),
      ),
    );
  }
}
