import 'package:flutter/material.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
class QuizScoreSummaryCard extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final bool passed;

  const QuizScoreSummaryCard({
    Key? key,
    required this.score,
    required this.totalQuestions,
    required this.passed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

   final backgroundColor = passed
    ? const Color(0xFFC8E6C9) // ✅ أخضر أغمق
    : const Color(0xFFFFCDD2); // ❌ أحمر أغمق

    final iconColor = passed
        ? const Color(0xFF2E7D32) // أخضر قوي
        : const Color(0xFFD32F2F); // أحمر قوي

    final textColor = passed
        ? const Color(0xFF1B5E20) // أخضر غامق
        : const Color(0xFFB71C1C); // أحمر غامق

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(
                passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 50,
                color: iconColor,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.quizScoreSummaryTitle,
                      style: textTheme.titleLarge?.copyWith(
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$score / $totalQuestions',
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      passed
                          ? l10n.quizScoreSummaryPassed
                          : l10n.quizScoreSummaryTryAgain,
                      style: textTheme.titleMedium?.copyWith(
                        color: textColor.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
