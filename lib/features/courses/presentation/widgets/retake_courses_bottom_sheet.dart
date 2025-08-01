import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height - 32,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DragHandle(),
            const SizedBox(height: 16),
            const RetakeCoursesTitle(),
            const SizedBox(height: 16),
            RetakeCoursesContent(
                selectedCoursesNotifier: _selectedCoursesNotifier),
            const SizedBox(height: 24),
            RetakeCoursesConfirmButton(
                selectedCoursesNotifier: _selectedCoursesNotifier),
          ],
        ),
      ),
    );
  }
}
