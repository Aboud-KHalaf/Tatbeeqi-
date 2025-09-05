import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/reports/domain/entities/report.dart';
import 'package:tatbeeqi/features/reports/domain/repositories/report_repository.dart';

class GetMyReportsUseCase implements UseCase<List<Report>, NoParams> {
  final ReportRepository repository;

  GetMyReportsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Report>>> call(NoParams params) async {
    return await repository.getMyReports();
  }
}
