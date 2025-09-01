import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
 import 'package:tatbeeqi/l10n/app_localizations.dart';

class QuizResultActionButton extends StatelessWidget {
  const QuizResultActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {          
          context.pop();
        },
        icon: const Icon(Icons.home),
        label: Text(l10n.quizGoHome),
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          textStyle:
              textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
