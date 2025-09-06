import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/core/widgets/app_error.dart';
import 'package:tatbeeqi/core/widgets/app_loading.dart';
import 'package:tatbeeqi/features/feedbacks/domain/entities/feedback.dart' as feedback_entity;
import 'package:tatbeeqi/features/feedbacks/presentation/manager/feedback_cubit/feedback_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyFeedbacksView extends StatefulWidget {
  const MyFeedbacksView({super.key});

  @override
  State<MyFeedbacksView> createState() => _MyFeedbacksViewState();
}

class _MyFeedbacksViewState extends State<MyFeedbacksView> {
  late final FeedbackCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = GetIt.instance<FeedbackCubit>();
    _cubit.getUserFeedbacks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ملاحظاتي'),
        ),
        body: BlocBuilder<FeedbackCubit, FeedbackState>(
          builder: (context, state) {
            if (state is FeedbackLoading) {
              return const AppLoading();
            }
            
            if (state is FeedbackError) {
              return AppError(
                onAction: () => _cubit.getUserFeedbacks(),
              );
            }
            
            if (state is FeedbacksLoaded) {
              if (state.feedbacks.isEmpty) {
                return const _EmptyFeedbacks();
              }
              
              return RefreshIndicator(
                onRefresh: () async => _cubit.getUserFeedbacks(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.feedbacks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _FeedbackCard(feedback: state.feedbacks[index]);
                  },
                ),
              );
            }
            
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _EmptyFeedbacks extends StatelessWidget {
  const _EmptyFeedbacks();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.feedback_outlined,
            size: 64,
            color: colors.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد ملاحظات',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'استخدم خاصية الملاحظات لإرسال اقتراحاتك وتقارير الأخطاء',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final feedback_entity.Feedback feedback;

  const _FeedbackCard({required this.feedback});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _TypeChip(type: feedback.type),
                const Spacer(),
                _StatusChip(status: feedback.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              feedback.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feedback.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              timeago.format(feedback.createdAt, locale: 'ar'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final feedback_entity.FeedbackType type;

  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    String label;
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case feedback_entity.FeedbackType.bug:
        label = 'خطأ';
        backgroundColor = colors.errorContainer;
        textColor = colors.onErrorContainer;
        break;
      case feedback_entity.FeedbackType.feature:
        label = 'اقتراح';
        backgroundColor = colors.primaryContainer;
        textColor = colors.onPrimaryContainer;
        break;
      case feedback_entity.FeedbackType.general:
        label = 'عام';
        backgroundColor = colors.surfaceVariant;
        textColor = colors.onSurfaceVariant;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final feedback_entity.FeedbackStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    String label;
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case feedback_entity.FeedbackStatus.pending:
        label = 'قيد الانتظار';
        backgroundColor = colors.surfaceVariant;
        textColor = colors.onSurfaceVariant;
        break;
      case feedback_entity.FeedbackStatus.inProgress:
        label = 'قيد المعالجة';
        backgroundColor = colors.tertiaryContainer;
        textColor = colors.onTertiaryContainer;
        break;
      case feedback_entity.FeedbackStatus.resolved:
        label = 'تم الحل';
        backgroundColor = colors.primaryContainer;
        textColor = colors.onPrimaryContainer;
        break;
      case feedback_entity.FeedbackStatus.closed:
        label = 'مغلق';
        backgroundColor = colors.outline.withOpacity(0.1);
        textColor = colors.outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
