import 'package:tatbeeqi/features/feedbacks/domain/entities/feedback.dart';

class FeedbackModel extends Feedback {
  const FeedbackModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    required super.description,
    super.screenshotUrl,
    super.deviceInfo,
    super.appVersion,
    required super.createdAt,
    required super.status,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      userId: json['user_id'],
      type: _feedbackTypeFromString(json['feedback_type']),
      title: json['title'],
      description: json['description'],
      screenshotUrl: json['screenshot_url'],
      deviceInfo: json['device_info'] != null 
          ? Map<String, dynamic>.from(json['device_info'])
          : null,
      appVersion: json['app_version'],
      createdAt: DateTime.parse(json['created_at']),
      status: _feedbackStatusFromString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'feedback_type': _feedbackTypeToString(type),
      'title': title,
      'description': description,
      'screenshot_url': screenshotUrl,
      'device_info': deviceInfo,
      'app_version': appVersion,
      'created_at': createdAt.toIso8601String(),
      'status': _feedbackStatusToString(status),
    };
  }

  static FeedbackType _feedbackTypeFromString(String type) {
    switch (type) {
      case 'bug':
        return FeedbackType.bug;
      case 'feature':
        return FeedbackType.feature;
      case 'general':
        return FeedbackType.general;
      default:
        return FeedbackType.general;
    }
  }

  static String _feedbackTypeToString(FeedbackType type) {
    switch (type) {
      case FeedbackType.bug:
        return 'bug';
      case FeedbackType.feature:
        return 'feature';
      case FeedbackType.general:
        return 'general';
    }
  }

  static FeedbackStatus _feedbackStatusFromString(String status) {
    switch (status) {
      case 'pending':
        return FeedbackStatus.pending;
      case 'in_progress':
        return FeedbackStatus.inProgress;
      case 'resolved':
        return FeedbackStatus.resolved;
      case 'closed':
        return FeedbackStatus.closed;
      default:
        return FeedbackStatus.pending;
    }
  }

  static String _feedbackStatusToString(FeedbackStatus status) {
    switch (status) {
      case FeedbackStatus.pending:
        return 'pending';
      case FeedbackStatus.inProgress:
        return 'in_progress';
      case FeedbackStatus.resolved:
        return 'resolved';
      case FeedbackStatus.closed:
        return 'closed';
    }
  }
}
