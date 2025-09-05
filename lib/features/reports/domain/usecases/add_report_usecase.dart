import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/reports/domain/entities/report.dart';
import 'package:tatbeeqi/features/reports/domain/repositories/report_repository.dart';

class AddReportUseCase implements UseCase<Report, AddReportParams> {
  final ReportRepository repository;

  AddReportUseCase(this.repository);

  @override
  Future<Either<Failure, Report>> call(AddReportParams params) async {
    return await repository.addReport(
      reportType: params.reportType,
      postId: params.postId,
      lessonId: params.lessonId,
      reason: params.reason,
    );
  }
}

class AddReportParams {
  final ReportType reportType;
  final String? postId;
  final int? lessonId;
  final String reason;

  AddReportParams({
    required this.reportType,
    this.postId,
    this.lessonId,
    required this.reason,
  });

  // Validation to ensure either postId or lessonId is provided based on reportType
  bool get isValid {
    switch (reportType) {
      case ReportType.post:
        return postId != null && postId!.isNotEmpty;
      case ReportType.lesson:
        return lessonId != null;
    }
  }
}
