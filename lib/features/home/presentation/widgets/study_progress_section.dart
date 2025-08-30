import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tatbeeqi/core/di/service_locator.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/recent_courses_cubit/recent_courses_cubit.dart';
import 'package:tatbeeqi/features/courses/presentation/manager/recent_courses_cubit/recent_courses_state.dart';

class StudyProgressSection extends StatefulWidget {
  const StudyProgressSection({super.key});

  @override
  State<StudyProgressSection> createState() => _StudyProgressSectionState();
}

class _StudyProgressSectionState extends State<StudyProgressSection>
    with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _fadeAnimations = [];
  List<Animation<Offset>> _slideAnimations = [];
  List<Course> _courses = const [];

  @override
  void initState() {
    super.initState();

    _setupAnimations(itemCount: _courses.length);

    _startStaggeredAnimations();
  }

  void _setupAnimations({required int itemCount}) {
    // dispose previous controllers if any
    if (_controllers.isNotEmpty) {
      for (final c in _controllers) {
        try {
          c.dispose();
        } catch (_) {}
      }
    }
    _controllers = List.generate(
      itemCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      ),
    );
    _fadeAnimations = _controllers
        .map((controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeOut),
            ))
        .toList();
    _slideAnimations = _controllers
        .map((controller) =>
            Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
            ))
        .toList();
  }

  void _startStaggeredAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    return BlocProvider(
      create: (_) {
        final cubit = sl<RecentCoursesCubit>();
        if (userId != null) cubit.load(userId);
        return cubit;
      },
      child: BlocConsumer<RecentCoursesCubit, RecentCoursesState>(
        listener: (context, state) {
          if (state is RecentCoursesLoaded) {
            setState(() {
              _courses = state.courses;
              _setupAnimations(itemCount: _courses.length);
              _startStaggeredAnimations();
            });
          }
        },
        builder: (context, state) {
          if (state is RecentCoursesLoading) {
            return _buildShimmer();
          }
          if (state is RecentCoursesError) {
            return _buildError(state.message);
          }
          if (state is RecentCoursesEmpty || userId == null) {
            return _buildEmpty();
          }
          // Loaded
          return SizedBox(
            height: 145,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                if (index >= _fadeAnimations.length) {
                  return _buildCourseCard(context, course, index, null, null,
                      userId: userId);
                }
                return AnimatedBuilder(
                  animation: _controllers[index],
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimations[index],
                      child: SlideTransition(
                        position: _slideAnimations[index],
                        child: child,
                      ),
                    );
                  },
                  child: _buildCourseCard(
                    context,
                    course,
                    index,
                    _fadeAnimations[index],
                    _slideAnimations[index],
                    userId: userId,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(
    BuildContext context,
    Course course,
    int index,
    Animation<double>? fadeAnimation,
    Animation<Offset>? slideAnimation,
    {required String userId}
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value.clamp(0.0, 1.0)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Container(
        width: 110,
        margin: const EdgeInsetsDirectional.only(end: 16),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              context
                  .read<RecentCoursesCubit>()
                  .track(userId, course.id);
              // TODO: Navigate to course details
            },
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              tween: Tween(begin: 1.0, end: 1.0),
              builder: (context, hoverValue, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Icon container with enhanced styling
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            child: Icon(
                              Icons.school_rounded,
                              size: 24,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Course title with better typography
                          Text(
                            course.courseName,
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                              height: 1.2,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          // Enhanced progress indicator
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'التقدم',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    '—', // Placeholder until progress available
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: TweenAnimationBuilder<double>(
                                  duration: Duration(
                                      milliseconds: 800 + (index * 200)),
                                  tween: Tween(begin: 0.0, end: 0.6),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, progressValue, child) {
                                    return FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: 0.0, // no progress yet
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: colorScheme.primary.withOpacity(0.4),
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) => Container(
          width: 110,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 145,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Center(
        child: Text(
          'ابدأ الدراسة اليوم — لا توجد مواد حديثة',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 145,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.error.withOpacity(0.4)),
      ),
      child: Center(
        child: Text(
          'حدث خطأ: $message',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onErrorContainer,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
