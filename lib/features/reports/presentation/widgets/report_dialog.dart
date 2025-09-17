import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/features/reports/domain/entities/report.dart';
import 'package:tatbeeqi/features/reports/presentation/manager/reports_cubit.dart';
import 'package:tatbeeqi/features/reports/presentation/manager/reports_state.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class ReportDialog extends StatefulWidget {
  final String? postId;
  final int? lessonId;
  final ReportType? initialReportType;

  const ReportDialog({
    super.key,
    this.postId,
    this.lessonId,
    this.initialReportType,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _postIdController = TextEditingController();
  final _lessonIdController = TextEditingController();

  late ReportType _selectedReportType;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedReportType = widget.initialReportType ?? ReportType.post;

    if (widget.postId != null) {
      _postIdController.text = widget.postId!;
      _selectedReportType = ReportType.post;
    }

    if (widget.lessonId != null) {
      _lessonIdController.text = widget.lessonId.toString();
      _selectedReportType = ReportType.lesson;
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _postIdController.dispose();
    _lessonIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<ReportsCubit, ReportsState>(
      listener: (context, state) {
        if (state is ReportAdded) {
          context.pop();
        } else if (state is ReportsError) {
          setState(() {
            _isSubmitting = false;
          });
        }
      },
      child: AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.report_outlined,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(l10n.submitReport),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Report Type Selection
                Text(
                  l10n.reportType,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildReportTypeSelector(),
                const SizedBox(height: 16),

                // Content ID Input
                if (_selectedReportType == ReportType.post) ...[
                  Text(
                    l10n.postId,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _postIdController,
                    decoration: InputDecoration(
                      hintText: l10n.enterPostId,
                      prefixIcon: const Icon(Icons.article_outlined),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.postIdRequired;
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  Text(
                    l10n.lessonId,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lessonIdController,
                    decoration: InputDecoration(
                      hintText: l10n.enterLessonId,
                      prefixIcon: const Icon(Icons.school_outlined),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.lessonIdRequired;
                      }
                      if (int.tryParse(value) == null) {
                        return l10n.invalidLessonId;
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),

                // Reason Input
                Text(
                  l10n.reason,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    hintText: l10n.describeIssue,
                    prefixIcon: const Icon(Icons.description_outlined),
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  maxLength: 500,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.reasonRequired;
                    }
                    if (value.trim().length < 10) {
                      return l10n.reasonTooShort;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : () => context.pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: _isSubmitting ? null : _submitReport,
            child: _isSubmitting
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(l10n.submitReport),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeSelector() {
    final l10n = AppLocalizations.of(context)!;

    return SegmentedButton<ReportType>(
      segments: [
        ButtonSegment<ReportType>(
          value: ReportType.post,
          label: Text(l10n.post),
          icon: const Icon(Icons.article_outlined),
        ),
        ButtonSegment<ReportType>(
          value: ReportType.lesson,
          label: Text(l10n.lesson),
          icon: const Icon(Icons.school_outlined),
        ),
      ],
      selected: {_selectedReportType},
      onSelectionChanged: (Set<ReportType> newSelection) {
        setState(() {
          _selectedReportType = newSelection.first;
          // Clear the opposite field when switching types
          if (_selectedReportType == ReportType.post) {
            _lessonIdController.clear();
          } else {
            _postIdController.clear();
          }
        });
      },
    );
  }

  void _submitReport() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final String? postId = _selectedReportType == ReportType.post
        ? _postIdController.text.trim()
        : null;

    final int? lessonId = _selectedReportType == ReportType.lesson
        ? int.tryParse(_lessonIdController.text.trim())
        : null;

    context.read<ReportsCubit>().addReport(
          reportType: _selectedReportType,
          postId: postId,
          lessonId: lessonId,
          reason: _reasonController.text.trim(),
        );
  }
}
