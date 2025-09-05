import 'package:equatable/equatable.dart';

enum ReportType { post, lesson }

enum ReportStatus { pending, reviewed, dismissed }

class Report extends Equatable {
  final String id;
  final String reporterId;
  final ReportType reportType;
  final String? postId;
  final int? lessonId;
  final String reason;
  final ReportStatus status;
  final DateTime createdAt;

  const Report({
    required this.id,
    required this.reporterId,
    required this.reportType,
    this.postId,
    this.lessonId,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  Report copyWith({
    String? id,
    String? reporterId,
    ReportType? reportType,
    String? postId,
    int? lessonId,
    String? reason,
    ReportStatus? status,
    DateTime? createdAt,
  }) {
    return Report(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      reportType: reportType ?? this.reportType,
      postId: postId ?? this.postId,
      lessonId: lessonId ?? this.lessonId,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        reporterId,
        reportType,
        postId,
        lessonId,
        reason,
        status,
        createdAt,
      ];
}
