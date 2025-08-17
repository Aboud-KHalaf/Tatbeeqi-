import 'package:equatable/equatable.dart';

class UserStreak extends Equatable {
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;

  const UserStreak({
    required this.userId,
    required this.currentStreak,
    required this.longestStreak,
    this.lastCompletedDate,
  });

  bool get hasStreakToday {
    if (lastCompletedDate == null) return false;
    final today = DateTime.now();
    final lastCompleted = lastCompletedDate!;
    return lastCompleted.year == today.year &&
           lastCompleted.month == today.month &&
           lastCompleted.day == today.day;
  }

  bool get isStreakActive {
    if (lastCompletedDate == null) return false;
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final lastCompleted = lastCompletedDate!;
    
    // Streak is active if completed today or yesterday
    return (lastCompleted.year == today.year &&
            lastCompleted.month == today.month &&
            lastCompleted.day == today.day) ||
           (lastCompleted.year == yesterday.year &&
            lastCompleted.month == yesterday.month &&
            lastCompleted.day == yesterday.day);
  }

  int get daysUntilStreakBreak {
    if (!isStreakActive) return 0;
    if (hasStreakToday) return 1;
    return 0; // Must complete today to maintain streak
  }

  @override
  List<Object?> get props => [
        userId,
        currentStreak,
        longestStreak,
        lastCompletedDate,
      ];
}
