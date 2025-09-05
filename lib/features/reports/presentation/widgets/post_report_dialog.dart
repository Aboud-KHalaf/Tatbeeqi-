import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/reports/domain/entities/report.dart';
import 'package:tatbeeqi/features/reports/presentation/manager/reports_cubit.dart';
import 'package:tatbeeqi/features/reports/presentation/manager/reports_state.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

enum PostReportReason {
  inappropriateContent,
  falseInformation,
  copyrightViolation,
  other,
}

class PostReportDialog extends StatefulWidget {
  final String postId;

  const PostReportDialog({
    super.key,
    required this.postId,
  });

  @override
  State<PostReportDialog> createState() => _PostReportDialogState();
}

class _PostReportDialogState extends State<PostReportDialog>
    with TickerProviderStateMixin {
  PostReportReason? _selectedReason;
  final _detailsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _detailsController.dispose();
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
          _showSuccessDialog(context, l10n);
        } else if (state is ReportsError) {
          _showErrorDialog(context, l10n, state.message);
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(l10n, colorScheme),
                          const SizedBox(height: 24),
                          _buildDescription(l10n, theme),
                          const SizedBox(height: 24),
                          _buildReasonSelector(l10n, colorScheme),
                          const SizedBox(height: 24),
                          _buildDetailsField(l10n, colorScheme),
                          const SizedBox(height: 32),
                          _buildActions(l10n, colorScheme),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ColorScheme colorScheme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.report_outlined,
            color: colorScheme.onErrorContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.reportPost,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
           
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.reportPostDescription,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonSelector(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.whyReporting,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...PostReportReason.values.map((reason) {
          final isSelected = _selectedReason == reason;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedReason = reason;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getReasonIcon(reason),
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getReasonText(reason, l10n),
                          style: TextStyle(
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDetailsField(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.additionalDetails,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _detailsController,
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: l10n.provideMoreContext,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor:
                colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(AppLocalizations l10n, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.cancel),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: BlocBuilder<ReportsCubit, ReportsState>(
            builder: (context, state) {
              final isLoading = state is ReportsLoading;
              return FilledButton(
                onPressed: (_selectedReason == null || isLoading)
                    ? null
                    : _submitReport,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(l10n.reportSubmitting),
                        ],
                      )
                    : Text(l10n.submit),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getReasonIcon(PostReportReason reason) {
    switch (reason) {
 
       case PostReportReason.inappropriateContent:
        return Icons.visibility_off;
      case PostReportReason.falseInformation:
        return Icons.fact_check;
      case PostReportReason.copyrightViolation:
        return Icons.copyright;
      case PostReportReason.other:
        return Icons.more_horiz;
    }
  }

  String _getReasonText(PostReportReason reason, AppLocalizations l10n) {
    switch (reason) {
  
      case PostReportReason.inappropriateContent:
        return l10n.inappropriateContent;
      case PostReportReason.falseInformation:
        return l10n.falseInformation;
      case PostReportReason.copyrightViolation:
        return l10n.copyrightViolation;
      case PostReportReason.other:
        return l10n.other;
    }
  }

  void _submitReport() {
    if (_selectedReason == null) return;

    HapticFeedback.mediumImpact();

    final reason =
        _getReasonText(_selectedReason!, AppLocalizations.of(context)!);
    final details = _detailsController.text.trim();
    final fullReason = details.isNotEmpty ? '$reason: $details' : reason;

    context.read<ReportsCubit>().addReport(
          reportType: ReportType.post,
          postId: widget.postId,
          lessonId: null,
          reason: fullReason,
        );
  }

  void _showSuccessDialog(BuildContext context, AppLocalizations l10n) {
    if (!mounted) return;

    Navigator.of(context).pop(); // Close report dialog

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.reportSuccess,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reportSuccessMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(
      BuildContext context, AppLocalizations l10n, String error) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.onErrorContainer,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.reportError,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reportErrorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitReport();
            },
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}
