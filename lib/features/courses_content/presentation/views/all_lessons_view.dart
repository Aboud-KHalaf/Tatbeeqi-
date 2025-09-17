import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/di/service_locator.dart';
import 'package:tatbeeqi/core/helpers/lesson_helper.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/recent_lessons/recent_lessons_cubit.dart';
import 'package:tatbeeqi/features/courses_content/presentation/manager/recent_lessons/recent_lessons_state.dart';

class AllLessonsView extends StatefulWidget {
  const AllLessonsView({super.key});

  @override
  State<AllLessonsView> createState() => _AllLessonsViewState();
}

class _AllLessonsViewState extends State<AllLessonsView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final RecentLessonsCubit _cubit;

  // Pagination state
  int _currentLimit = 10; // load 10 at a time
  bool _isLoadingMore = false;
  bool _hasReachedMax = false;

  // Cached data for client-side filter/sort while loading more
  List<Lesson> _allLessons = [];

  @override
  void initState() {
    super.initState();
    _cubit = sl<RecentLessonsCubit>();
    _cubit.fetch(limit: _currentLimit);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_hasReachedMax || _isLoadingMore) return;
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent * 0.9;
    if (_scrollController.position.pixels >= threshold) {
      _loadMore();
    }
  }

  void _loadMore() {
    // Increase limit and refetch. This reuses RecentLessonsCubit without data-layer changes.
    setState(() {
      _isLoadingMore = true;
      _currentLimit += 10;
    });
    _cubit.fetch(limit: _currentLimit);
  }

  List<Lesson> _applySearchAndSort(
      List<Lesson> lessons, ColorScheme colorScheme) {
    // Sort by lesson type (custom order), then by publish date desc if available
    final order = {
      ContentType.video: 0,
      ContentType.voice: 1,
      ContentType.reading: 2,
      ContentType.pdf: 3,
      ContentType.quiz: 4,
    };

    final query = _searchController.text.trim().toLowerCase();

    List<Lesson> filtered = lessons.where((l) {
      if (query.isEmpty) return true;
      final inTitle = l.title.toLowerCase().contains(query);
      final inCreator = (l.createdBy ?? '').toLowerCase().contains(query);
      final inTags =
          (l.tags ?? const []).any((t) => t.toLowerCase().contains(query));
      return inTitle || inCreator || inTags;
    }).toList();

    filtered.sort((a, b) {
      final byType =
          (order[a.lessonType] ?? 999).compareTo(order[b.lessonType] ?? 999);
      if (byType != 0) return byType;
      final ad = a.publishedAt ??
          a.updatedAt ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final bd = b.publishedAt ??
          b.updatedAt ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return bd.compareTo(ad); // newest first within the same type
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الدروس المضافة مؤخرا'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: BlocProvider.value(
          value: _cubit,
          child: BlocConsumer<RecentLessonsCubit, RecentLessonsState>(
            listener: (context, state) {
              if (state is RecentLessonsLoaded) {
                // Determine if we've reached max: if length didn't grow after asking for more
                final grew = state.lessons.length > _allLessons.length;
                _hasReachedMax = !grew && _currentLimit > 10;
                _allLessons = state.lessons;
                _isLoadingMore = false;
                setState(() {});
              } else if (state is RecentLessonsError) {
                _isLoadingMore = false;
                setState(() {});
              }
            },
            builder: (context, state) {
              if (state is RecentLessonsLoading && _allLessons.isEmpty) {
                return _buildShimmer(colorScheme);
              }

              if (state is RecentLessonsError && _allLessons.isEmpty) {
                return _buildError(colorScheme, textTheme, state.message);
              }

              if (state is RecentLessonsEmpty) {
                return const SizedBox.shrink();
              }

              // Use cached lessons to avoid jank during load-more
              final lessons = _applySearchAndSort(_allLessons, colorScheme);
              final rows = _buildSectionedRows(lessons);

              return Column(
                children: [
                  _SearchBar(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: rows.length + 1,
                      itemBuilder: (context, index) {
                        if (index < rows.length) {
                          final row = rows[index];
                          if (row.isHeader) {
                            return _buildTypeHeader(
                              context,
                              row.headerType!,
                              colorScheme,
                              textTheme,
                            );
                          } else {
                            final lesson = row.lesson!;
                            return _buildRecentLessonItem(
                              context,
                              lesson,
                              colorScheme,
                              textTheme,
                            );
                          }
                        }
                        // Footer: loading or end message
                        if (_isLoadingMore) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        } else if (_hasReachedMax) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                'تم عرض كل الدروس',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRecentLessonItem(
    BuildContext context,
    Lesson lesson,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final icon = LessonHelper.getIcon(lesson.lessonType);
    final typeColor = LessonHelper.getTypeColor(lesson.lessonType, colorScheme);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: typeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (lesson.createdBy != null ||
                        lesson.durationMinutes > 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        _buildSubtitle(lesson),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(ColorScheme colorScheme) {
    return Column(
      children: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: colorScheme.outline.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 10,
                      width: 160,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 48,
                height: 22,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildError(
      ColorScheme colorScheme, TextTheme textTheme, String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.error.withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline,
              color: colorScheme.onErrorContainer, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'حدث خطأ: $message',
              style: textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onErrorContainer),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _buildSubtitle(Lesson lesson) {
    final parts = <String>[];
    if (lesson.createdBy != null && lesson.createdBy!.trim().isNotEmpty) {
      parts.add(lesson.createdBy!.trim());
    }
    if (lesson.durationMinutes > 0) {
      parts.add('${lesson.durationMinutes} دقيقة');
    }
    return parts.join(' • ');
  }
}

class _LessonRow {
  final bool isHeader;
  final ContentType? headerType;
  final Lesson? lesson;

  const _LessonRow.header(this.headerType)
      : isHeader = true,
        lesson = null;

  const _LessonRow.item(this.lesson)
      : isHeader = false,
        headerType = null;
}

List<_LessonRow> _buildSectionedRows(List<Lesson> lessons) {
  final rows = <_LessonRow>[];
  ContentType? lastType;
  for (final l in lessons) {
    if (lastType != l.lessonType) {
      rows.add(_LessonRow.header(l.lessonType));
      lastType = l.lessonType;
    }
    rows.add(_LessonRow.item(l));
  }
  return rows;
}

Widget _buildTypeHeader(
  BuildContext context,
  ContentType type,
  ColorScheme colorScheme,
  TextTheme textTheme,
) {
  final icon = LessonHelper.getIcon(type);
  final text = LessonHelper.getTypeText(type, context);
  final color = LessonHelper.getTypeColor(type, colorScheme);
  return Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  color.withOpacity(0.35),
                  colorScheme.outline.withOpacity(0.08),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'ابحث عن الدروس...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.4)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
