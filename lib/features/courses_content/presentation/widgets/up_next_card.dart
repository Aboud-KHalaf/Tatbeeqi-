import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';

class UpNextCard extends StatefulWidget {
  final Lesson lesson;
  final VoidCallback onPressed;
  const UpNextCard({super.key, required this.lesson, required this.onPressed});

  @override
  State<UpNextCard> createState() => _UpNextCardState();
}

class _UpNextCardState extends State<UpNextCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'أكمل من هنا',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'التالي',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Card(
                elevation: _isHovered ? 8 : 2,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: colorScheme.primaryContainer.withValues(alpha: 0.05),
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() => _isHovered = true);
                    _animationController.forward();
                  },
                  onExit: (_) {
                    setState(() => _isHovered = false);
                    _animationController.reverse();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primaryContainer.withValues(alpha: 0.1),
                          colorScheme.surface,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.lesson.title,
                                      style:
                                          theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.onSurface,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'المحاضرة التالية في المقرر',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.lesson.isDownloadable)
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer
                                        .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.download_outlined,
                                      color: colorScheme.primary,
                                    ),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      // TODO: Implement download functionality
                                    },
                                    tooltip: 'تحميل المحاضرة',
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _getTypeColor(
                                          widget.lesson.lessonType, colorScheme)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getTypeColor(
                                            widget.lesson.lessonType,
                                            colorScheme)
                                        .withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getIcon(widget.lesson.lessonType),
                                      size: 16,
                                      color: _getTypeColor(
                                          widget.lesson.lessonType,
                                          colorScheme),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _getTypeText(widget.lesson.lessonType),
                                      style:
                                          theme.textTheme.labelMedium?.copyWith(
                                        color: _getTypeColor(
                                            widget.lesson.lessonType,
                                            colorScheme),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: colorScheme.outline
                                        .withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.lesson.durationMinutes} دقيقة',
                                      style:
                                          theme.textTheme.labelMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    widget.onPressed();
                                  },
                                  icon: const Icon(Icons.play_arrow, size: 20),
                                  label: const Text('ابدأ الآن'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    foregroundColor: colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: _isHovered ? 4 : 2,
                                    shadowColor: colorScheme.primary
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Color _getTypeColor(ContentType type, ColorScheme colorScheme) {
    switch (type) {
      case ContentType.video:
        return Colors.red.shade600;
      case ContentType.voice:
        return Colors.orange.shade600;
      case ContentType.reading:
        return Colors.blue.shade600;
      case ContentType.quiz:
        return Colors.green.shade600;
    }
  }

  IconData _getIcon(ContentType type) {
    switch (type) {
      case ContentType.video:
        return Icons.play_arrow;
      case ContentType.voice:
        return Icons.headset;
      case ContentType.reading:
        return Icons.book;
      case ContentType.quiz:
        return Icons.quiz;
    }
  }

  // Color _getIconColor(ContentType type, ColorScheme colorScheme) {
  //   switch (type) {
  //     case ContentType.video:
  //       return Colors.red.shade600;
  //     case ContentType.voice:
  //       return Colors.orange.shade600;
  //     case ContentType.reading:
  //       return Colors.blue.shade600;
  //     case ContentType.quiz:
  //       return Colors.green.shade600;
  //   }
  // }

  String _getTypeText(ContentType type) {
    switch (type) {
      case ContentType.video:
        return 'فيديو';
      case ContentType.voice:
        return 'صوت';
      case ContentType.reading:
        return 'قراءة';
      case ContentType.quiz:
        return 'اختبار';
    }
  }
}
