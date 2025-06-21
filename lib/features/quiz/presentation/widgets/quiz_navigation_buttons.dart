import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
class QuizNavigationButtons extends StatelessWidget {
  final bool isFirstQuestion;
  final bool isLastQuestion;
  final bool isAnswered;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onSubmit;

  const QuizNavigationButtons({
    Key? key,
    required this.isFirstQuestion,
    required this.isLastQuestion,
    required this.isAnswered,
    this.onPrevious,
    this.onNext,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        if (!isFirstQuestion)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onPrevious,
              icon: const Icon(Icons.arrow_back),
              label:  Text(l10n.quizPrev),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          )
        else
          const Expanded(child: SizedBox.shrink()),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isAnswered
                ? (isLastQuestion ? onSubmit : onNext)
                : null,
            icon: Icon(isLastQuestion ? Icons.check_circle_outline : Icons.arrow_forward),
            label: Text(isLastQuestion ? l10n.quizSubmit : l10n.quizNext),
            style: ElevatedButton.styleFrom(
              backgroundColor: isLastQuestion ? Colors.green.shade600 : colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 3,
            ),
          ),
        ),
      ],
    );
  }
}
