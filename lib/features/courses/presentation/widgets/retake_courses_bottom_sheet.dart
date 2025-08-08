import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/drag_handle.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/retake_courses_confirm_button.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/retake_courses_content.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/retake_courses_title.dart';

class RetakeCoursesBottomSheet extends StatefulWidget {
  const RetakeCoursesBottomSheet({super.key});

  @override
  State<RetakeCoursesBottomSheet> createState() =>
      _RetakeCoursesBottomSheetState();
}

class _RetakeCoursesBottomSheetState extends State<RetakeCoursesBottomSheet>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<List<Course>> _selectedCoursesNotifier =
      ValueNotifier([]);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _selectedCoursesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height - 32,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, -8),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced drag handle with haptic feedback
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: const DragHandle(),
                      ),
                    ),
                    
                    // Content with proper Material 3 spacing
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const RetakeCoursesTitle(),
                            const SizedBox(height: 24),
                            Expanded(
                              child: RetakeCoursesContent(
                                selectedCoursesNotifier: _selectedCoursesNotifier,
                              ),
                            ),
                            const SizedBox(height: 24),
                            RetakeCoursesConfirmButton(
                              selectedCoursesNotifier: _selectedCoursesNotifier,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
