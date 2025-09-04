import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/widgets/app_error.dart';
import 'package:tatbeeqi/core/widgets/app_loading.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/references/domain/entities/reference.dart';
import 'package:tatbeeqi/features/references/presentation/manager/references_cubit.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tatbeeqi/core/di/service_locator.dart' as di;

class ReferencesView extends StatefulWidget {
  final Course course;
  const ReferencesView({super.key, required this.course});

  @override
  State<ReferencesView> createState() => _ReferencesViewState();
}

class _ReferencesViewState extends State<ReferencesView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ReferencesCubit>()
        ..fetchReferences(widget.course.id.toString()),
      child: Scaffold(
        body: BlocBuilder<ReferencesCubit, ReferencesState>(
          builder: (context, state) {
            if (state is ReferencesLoading) {
              return const AppLoading(fullscreen: true);
            }

            if (state is ReferencesError) {
              return AppError(
                fullscreen: true,
                message: state.message,
                onAction: () => context
                    .read<ReferencesCubit>()
                    .fetchReferences(widget.course.id.toString()),
              );
            }

            if (state is ReferencesLoaded) {
              final items = state.references;
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
                            color: colorScheme.secondaryContainer
                                .withOpacity(0.08),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: colorScheme.secondary
                                  .withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            size: 32,
                            color: colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l10n.referencesEmptyTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.referencesEmptySubtitle,
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

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final Reference reference = items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(_getIconForType(reference.type)),
                      title: Text(reference.title),
                      subtitle: Text(
                        reference.url,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () async {
                        final url = Uri.parse(reference.url);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                  );
                },
              );
            }

            // Initial
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

IconData _getIconForType(String type) {
  switch (type) {
    case 'documentation':
      return Icons.book;
    case 'video':
      return Icons.video_library;
    default:
      return Icons.link;
  }
}
