import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class CourseResourcesCard extends StatelessWidget {
  const CourseResourcesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.coursesContentCourseResources,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              // الموارد الإضافية ستُضاف هنا لاحقًا
            ],
          ),
        ),
      ),
    );
  }
}
