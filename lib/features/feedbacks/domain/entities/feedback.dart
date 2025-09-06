import 'package:equatable/equatable.dart';

enum FeedbackType { bug, feature, general }

enum FeedbackStatus { pending, inProgress, resolved, closed }

class Feedback extends Equatable {
  final String id;
  final String userId;
  final FeedbackType type;
  final String title;
  final String description;
  final String? screenshotUrl;
  final Map<String, dynamic>? deviceInfo;
  final String? appVersion;
  final DateTime createdAt;
  final FeedbackStatus status;

  const Feedback({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    this.screenshotUrl,
    this.deviceInfo,
    this.appVersion,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        description,
        screenshotUrl,
        deviceInfo,
        appVersion,
        createdAt,
        status,
      ];
}
