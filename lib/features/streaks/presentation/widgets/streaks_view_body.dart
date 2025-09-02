import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/widgets/app_error.dart';
import 'package:tatbeeqi/core/widgets/app_loading.dart';
import '../cubit/streaks_cubit.dart';
import '../cubit/streaks_state.dart';
import 'streaks_header.dart';
import 'streaks_loaded_state.dart';
import 'streaks_updating_state.dart';

class StreaksViewBody extends StatefulWidget {
  const StreaksViewBody({super.key});

  @override
  State<StreaksViewBody> createState() => _StreaksViewBodyState();
}

class _StreaksViewBodyState extends State<StreaksViewBody>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late Animation<double> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUserStreak();
  }

  /// Sets up the slide and fade animations for the header.
  void _setupAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerSlideAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    ));

    _headerAnimationController.forward();
  }

  /// Initiates the cubit to load the user's streak data.
  void _loadUserStreak() {
    context.read<StreaksCubit>().loadUserStreak();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          await context.read<StreaksCubit>().refreshStreak();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Extracted header widget with animation controllers.
            StreaksHeader(
              headerAnimationController: _headerAnimationController,
              headerSlideAnimation: _headerSlideAnimation,
              headerFadeAnimation: _headerFadeAnimation,
            ),
            // Main content area, which rebuilds based on the BLoC state.
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<StreaksCubit, StreaksState>(
                  builder: (context, state) {
                    if (state is StreaksLoading) {
                      return const AppLoading();
                    } else if (state is StreaksLoaded) {
                      return StreaksLoadedState(state: state);
                    } else if (state is StreaksUpdating) {
                      return StreaksUpdatingState(state: state);
                    } else if (state is StreaksError) {
                      return AppError(
                        onAction: () =>
                            context.read<StreaksCubit>().refreshStreak(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
