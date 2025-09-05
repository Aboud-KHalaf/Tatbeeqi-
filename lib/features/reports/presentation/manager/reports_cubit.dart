import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/usecases/usecase.dart';
import 'package:tatbeeqi/features/reports/domain/entities/report.dart';
import 'package:tatbeeqi/features/reports/domain/usecases/add_report_usecase.dart';
import 'package:tatbeeqi/features/reports/domain/usecases/get_my_reports_usecase.dart';
import 'package:tatbeeqi/features/reports/presentation/manager/reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final AddReportUseCase addReportUseCase;
  final GetMyReportsUseCase getMyReportsUseCase;

  ReportsCubit({
    required this.addReportUseCase,
    required this.getMyReportsUseCase,
  }) : super(ReportsInitial());

  Future<void> getMyReports() async {
    emit(ReportsLoading());

    final result = await getMyReportsUseCase(NoParams());

    result.fold(
      (failure) => emit(ReportsError(failure.message)),
      (reports) => emit(MyReportsLoaded(reports)),
    );
  }

  Future<void> addReport({
    required ReportType reportType,
    String? postId,
    int? lessonId,
    required String reason,
  }) async {
    emit(ReportsAddingReport());

    final params = AddReportParams(
      reportType: reportType,
      postId: postId,
      lessonId: lessonId,
      reason: reason,
    );

    // Validate parameters
    if (!params.isValid) {
      emit(const ReportsError('Invalid report parameters'));
      return;
    }

    final result = await addReportUseCase(params);

    result.fold(
      (failure) => emit(ReportsError(failure.message)),
      (report) {
        emit(ReportAdded(report));
        // Refresh the reports list after adding
        getMyReports();
      },
    );
  }

  void resetState() {
    emit(ReportsInitial());
  }
}
