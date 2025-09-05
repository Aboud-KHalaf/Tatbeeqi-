import 'package:equatable/equatable.dart';
import 'package:tatbeeqi/features/reports/domain/entities/report.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsAddingReport extends ReportsState {}

class MyReportsLoaded extends ReportsState {
  final List<Report> reports;

  const MyReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

class ReportAdded extends ReportsState {
  final Report report;

  const ReportAdded(this.report);

  @override
  List<Object?> get props => [report];
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
