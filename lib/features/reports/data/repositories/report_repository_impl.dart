import 'package:dartz/dartz.dart';
import 'package:tatbeeqi/core/error/exceptions.dart';
import 'package:tatbeeqi/core/error/failures.dart';
import 'package:tatbeeqi/core/network/network_info.dart';
import 'package:tatbeeqi/features/reports/data/datasources/reports_remote_datasource.dart';
import 'package:tatbeeqi/features/reports/domain/entities/report.dart';
import 'package:tatbeeqi/features/reports/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ReportRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Report>> addReport({
    required ReportType reportType,
    String? postId,
    int? lessonId,
    required String reason,
  }) async {
    if (await networkInfo.isConnected()) {
      try {
        final report = await remoteDataSource.addReport(
          reportType: reportType,
          postId: postId,
          lessonId: lessonId,
          reason: reason,
        );
        return Right(report);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Report>>> getMyReports() async {
    if (await networkInfo.isConnected()) {
      try {
        final reports = await remoteDataSource.getMyReports();
        return Right(reports);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Report>>> getAllReports() async {
    if (await networkInfo.isConnected()) {
      try {
        final reports = await remoteDataSource.getAllReports();
        return Right(reports);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Report>> updateReportStatus({
    required String reportId,
    required ReportStatus status,
  }) async {
    if (await networkInfo.isConnected()) {
      try {
        final report = await remoteDataSource.updateReportStatus(
          reportId: reportId,
          status: status,
        );
        return Right(report);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
