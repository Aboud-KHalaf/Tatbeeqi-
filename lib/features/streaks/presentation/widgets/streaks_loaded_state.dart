import 'package:flutter/material.dart';
import '../cubit/streaks_state.dart';
import '../widgets/streak_card.dart';
import '../widgets/streak_calendar.dart';
import '../widgets/streak_motivation_card.dart';
import 'streaks_action_button.dart';

class StreaksLoadedState extends StatelessWidget {
  const StreaksLoadedState({super.key, required this.state});

  final StreaksLoaded state;

  @override
  Widget build(BuildContext context) {
    final streak = state.streak;

    return Column(
      children: [
        StreakMotivationCard(
          currentStreak: streak.currentStreak,
          hasStreakToday: streak.hasStreakToday,
          isStreakActive: streak.isStreakActive,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: StreakCard(
                streakCount: streak.currentStreak,
                title: 'السلسلة الحالية',
                icon: Icons.local_fire_department,
                color: Colors.orange,
                isActive: streak.isStreakActive,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StreakCard(
                streakCount: streak.longestStreak,
                title: 'أطول سلسلة',
                icon: Icons.emoji_events,
                color: Colors.amber,
                isActive: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        StreakCalendar(
          lastCompletedDate: streak.lastCompletedDate,
          currentStreak: streak.currentStreak,
        ),
        const SizedBox(height: 24),
        if (!streak.hasStreakToday) const StreaksActionButton(),
      ],
    );
  }
}
