import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/features/reports/domain/entities/report.dart';

abstract class ReportRepository {
  /// Add a new report
  Future<Either<Failure, Report>> addReport({
    required ReportType reportType,
    String? postId,
    int? lessonId,
    required String reason,
  });

  /// Get reports submitted by the current user
  Future<Either<Failure, List<Report>>> getMyReports();

  /// Get all reports (for admin purposes - future use)
  Future<Either<Failure, List<Report>>> getAllReports();

  /// Update report status (for admin purposes - future use)
  Future<Either<Failure, Report>> updateReportStatus({
    required String reportId,
    required ReportStatus status,
  });
}
