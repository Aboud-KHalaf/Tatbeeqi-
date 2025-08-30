import 'package:equatable/equatable.dart';

class RecentCourse extends Equatable {
  final String userId;
  final int courseId;
  final int lastVisit; // unix millis

  const RecentCourse({
    required this.userId,
    required this.courseId,
    required this.lastVisit,
  });

  @override
  List<Object?> get props => [userId, courseId, lastVisit];
}
