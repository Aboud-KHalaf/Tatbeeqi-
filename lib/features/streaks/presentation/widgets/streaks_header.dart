import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/auth/presentation/manager/user_cubit/user_cubit.dart';
import 'package:tatbeeqi/features/auth/presentation/manager/user_cubit/user_state.dart';

class StreaksHeader extends StatelessWidget {
  const StreaksHeader({
    super.key,
    required this.headerAnimationController,
    required this.headerSlideAnimation,
    required this.headerFadeAnimation,
  });

  final AnimationController headerAnimationController;
  final Animation<double> headerSlideAnimation;
  final Animation<double> headerFadeAnimation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    String text = 'واصل زخم التعلم لديك!';
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: AnimatedBuilder(
          animation: headerAnimationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, headerSlideAnimation.value),
              child: Opacity(
                opacity: headerFadeAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary.withOpacity(0.1),
                        colorScheme.secondary.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.local_fire_department,
                                color: colorScheme.primary,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'سلاسل التعلم',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  BlocListener<UserCubit, UserState>(
                                    listener: (context, state) {
                                      if (state is UserLoaded) {
                                        text =
                                            'واصل زخم التعلم لديك يا ${state.user.name}';
                                      }
                                    },
                                    child: Text(
                                      text,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
