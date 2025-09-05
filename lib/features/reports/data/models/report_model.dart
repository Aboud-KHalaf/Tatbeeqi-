import 'package:tatbeeqi/features/reports/domain/entities/report.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.id,
    required super.reporterId,
    required super.reportType,
    super.postId,
    super.lessonId,
    required super.reason,
    required super.status,
    required super.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      reporterId: json['reporter_id'] as String,
      reportType: _parseReportType(json['report_type'] as String),
      postId: json['post_id'] as String?,
      lessonId: json['lesson_id'] as int?,
      reason: json['reason'] as String,
      status: _parseReportStatus(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporter_id': reporterId,
      'report_type': _reportTypeToString(reportType),
      'post_id': postId,
      'lesson_id': lessonId,
      'reason': reason,
      'status': _reportStatusToString(status),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Convert from domain entity to model
  factory ReportModel.fromEntity(Report report) {
    return ReportModel(
      id: report.id,
      reporterId: report.reporterId,
      reportType: report.reportType,
      postId: report.postId,
      lessonId: report.lessonId,
      reason: report.reason,
      status: report.status,
      createdAt: report.createdAt,
    );
  }

  /// Helper methods for enum conversion
  static ReportType _parseReportType(String type) {
    switch (type) {
      case 'post':
        return ReportType.post;
      case 'lesson':
        return ReportType.lesson;
      default:
        throw ArgumentError('Unknown report type: $type');
    }
  }

  static ReportStatus _parseReportStatus(String status) {
    switch (status) {
      case 'pending':
        return ReportStatus.pending;
      case 'reviewed':
        return ReportStatus.reviewed;
      case 'dismissed':
        return ReportStatus.dismissed;
      default:
        throw ArgumentError('Unknown report status: $status');
    }
  }

  static String _reportTypeToString(ReportType type) {
    switch (type) {
      case ReportType.post:
        return 'post';
      case ReportType.lesson:
        return 'lesson';
    }
  }

  static String _reportStatusToString(ReportStatus status) {
    switch (status) {
      case ReportStatus.pending:
        return 'pending';
      case ReportStatus.reviewed:
        return 'reviewed';
      case ReportStatus.dismissed:
        return 'dismissed';
    }
  }
}
