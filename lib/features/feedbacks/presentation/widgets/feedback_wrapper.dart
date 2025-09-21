import 'dart:io';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/features/feedbacks/domain/entities/feedback.dart'
    as feedback_entity;
import 'package:tatbeeqi/features/feedbacks/presentation/manager/feedback_cubit/feedback_cubit.dart';

class FeedbackWrapper extends StatelessWidget {
  final Widget child;

  const FeedbackWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      theme: FeedbackThemeData(
        feedbackSheetColor: Theme.of(context).colorScheme.surface,
        drawColors: [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
        ],
      ),
      localizationsDelegates: const [
  
        // Add your localization delegates here if needed

      ],
      localeOverride: const Locale('ar'),
      child: Builder(
        builder: (context) => child,
      ),
    );
  }

  static void showFeedbackDialog(BuildContext context) {
    BetterFeedback.of(context).show((UserFeedback userFeedback) async {
      await _submitFeedback(context, userFeedback);
    });
  }

  static void showMyFeedbacks(BuildContext context) {
    context.push(AppRoutes.myFeedbacks);
  }

  static Future<void> _submitFeedback(
    BuildContext context,
    UserFeedback userFeedback,
  ) async {
    final cubit = GetIt.instance<FeedbackCubit>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('جاري إرسال الملاحظة...'),
          ],
        ),
      ),
    );

    try {
      // Get device info
      final deviceInfo = await _getDeviceInfo();

      // Submit feedback
      await cubit.submitFeedback(
        type: feedback_entity.FeedbackType.general,
        title: 'ملاحظة من المستخدم',
        description: userFeedback.text,
        screenshotUrl:
            null, // You can implement screenshot upload to Supabase storage
        deviceInfo: deviceInfo,
        appVersion: '1.0.0', // Get from package_info_plus if needed
      );

      // Close loading dialog
      if (context.mounted) context.pop();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال الملاحظة بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) context.pop();

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في إرسال الملاحظة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  static Future<Map<String, dynamic>> _getDeviceInfo() async {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'locale': Platform.localeName,
    };
  }
}
