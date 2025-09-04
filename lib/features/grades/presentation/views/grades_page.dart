import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/widgets/app_error.dart';
import 'package:tatbeeqi/core/widgets/app_loading.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/grades/domain/entities/grade.dart';
import 'package:tatbeeqi/features/grades/presentation/manager/grades_cubit.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
 
class GradesView extends StatefulWidget {
  final Course course;
  const GradesView({super.key, required this.course});

  @override
  State<GradesView> createState() => _GradesViewState();
}

class _GradesViewState extends State<GradesView> {
  @override
  void initState() {
    context.read<GradesCubit>().fetchByCourse(widget.course.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GradesCubit, GradesState>(
        builder: (context, state) {
          if (state is GradesLoading) {
            return const AppLoading(fullscreen: true);
          }
    
          if (state is GradesError) {
            return AppError(
              fullscreen: true,
              message: state.message,
              onAction: () => context
                  .read<GradesCubit>()
                  .fetchByCourse(widget.course.id.toString()),
            );
          }
    
          if (state is GradesLoaded) {
            final items = state.grades;
            if (items.isEmpty) {
              final l10n = AppLocalizations.of(context)!;
              final theme = Theme.of(context);
              final colorScheme = theme.colorScheme;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color:
                              colorScheme.secondaryContainer.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: colorScheme.secondary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.analytics_outlined,
                          size: 32,
                          color: colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.gradesEmptyTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.gradesEmptySubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
    
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final Grade grade = items[index];
                final theme = Theme.of(context);
                final colorScheme = theme.colorScheme;
                final scoreColor = grade.score >= 80
                    ? Colors.green
                    : grade.score >= 60
                        ? Colors.orange
                        : Colors.red;
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    title: Text(
                      '${grade.lessonTitle}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      _formatSubmissionDate(grade.submissionDate),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Chip(
                      label: Text(
                        '${grade.score.toStringAsFixed(1)}%',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: scoreColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                );
              },
            );
          }
    
          // Initial
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatSubmissionDate(DateTime date) {
    final d = date.toLocal();
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }
}
