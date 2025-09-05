import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/reports/domain/entities/report.dart';
import 'package:tatbeeqi/features/reports/presentation/manager/reports_cubit.dart';
import 'package:tatbeeqi/features/reports/presentation/manager/reports_state.dart';
import 'package:tatbeeqi/features/reports/presentation/widgets/report_card.dart';
import 'package:tatbeeqi/features/reports/presentation/widgets/report_dialog.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class MyReportsView extends StatefulWidget {
  const MyReportsView({super.key});

  @override
  State<MyReportsView> createState() => _MyReportsViewState();
}

class _MyReportsViewState extends State<MyReportsView> {
  @override
  void initState() {
    super.initState();
    context.read<ReportsCubit>().getMyReports();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.myReports),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: () => _showReportDialog(context),
            icon: const Icon(Icons.add_rounded),
            tooltip: l10n.addReport,
          ),
        ],
      ),
      body: BlocConsumer<ReportsCubit, ReportsState>(
        listener: (context, state) {
          if (state is ReportsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          } else if (state is ReportAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.reportSubmitted),
                backgroundColor: colorScheme.primary,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ReportsLoading) {
            return _buildLoadingState();
          } else if (state is MyReportsLoaded) {
            return _buildReportsListState(state.reports);
          } else if (state is ReportsError) {
            return _buildErrorState(state.message);
          }
          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReportDialog(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildReportsListState(List<Report> reports) {
    if (reports.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ReportsCubit>().getMyReports();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          return ReportCard(
            report: reports[index],
            onTap: () => _showReportDetails(context, reports[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.report_outlined,
            size: 80,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noReportsYet,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noReportsDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _showReportDialog(context),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.createFirstReport),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 80,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.errorLoadingReports,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.read<ReportsCubit>().getMyReports(),
            icon: const Icon(Icons.refresh_rounded),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ReportsCubit>(),
        child: const ReportDialog(),
      ),
    );
  }

  void _showReportDetails(BuildContext context, Report report) {
    // TODO: Implement report details dialog if needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report ID: ${report.id}'),
      ),
    );
  }
}
