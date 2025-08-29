import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/utils/app_methods.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class StartNewChallengeButtonWidget extends StatelessWidget {
  const StartNewChallengeButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add_circle_outline, size: 20),
        label: Text(
          l10n.homeStartNewChallenge,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onPressed: () {
          showAddEditTodoBottomSheet(context);
        },
      ),
    );
  }
}
