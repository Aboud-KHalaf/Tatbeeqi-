import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/drag_handle.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/retake_courses_confirm_button.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/retake_courses_content.dart';
import 'package:tatbeeqi/features/courses/presentation/widgets/retake_courses_title.dart';
import 'package:go_router/go_router.dart';

class RetakeCoursesBottomSheet extends StatefulWidget {
  const RetakeCoursesBottomSheet({super.key});

  @override
  State<RetakeCoursesBottomSheet> createState() =>
      _RetakeCoursesBottomSheetState();
}

class _RetakeCoursesBottomSheetState extends State<RetakeCoursesBottomSheet> {
  final ValueNotifier<List<Course>> _selectedCoursesNotifier =
      ValueNotifier([]);

  @override
  void dispose() {
    _selectedCoursesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                context.pop();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const DragHandle(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RetakeCoursesTitle(),
                    const SizedBox(height: 16),
                    Expanded(
                      child: RetakeCoursesContent(
                        selectedCoursesNotifier: _selectedCoursesNotifier,
                      ),
                    ),
                    const SizedBox(height: 12),
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
    );
  }
}
