import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';

class PostCardHeader extends StatefulWidget {
  final Post post;
  const PostCardHeader({super.key, required this.post});

  @override
  State<PostCardHeader> createState() => _PostCardHeaderState();
}

class _PostCardHeaderState extends State<PostCardHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  late final Animation<double> _scaleAnim;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      value: 0,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _setHover(bool v) {
    if (!mounted) return;
    setState(() => _isHovered = v);
    if (v) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final post = widget.post;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      cursor: SystemMouseCursors.basic,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            _Avatar(colorScheme: colorScheme),
            const SizedBox(width: 12.0),
            // Author + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          post.authorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Optional role/verified badge space (placeholder for future)
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color:
                            colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          timeago.format(post.createdAt, locale: 'ar_short'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _MoreMenuButton(isHovered: _isHovered),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    // Placeholder avatar using initials icon; replace with NetworkImage when available.
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surfaceContainerHighest,
            colorScheme.surfaceContainerHigh,
          ],
        ),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Icon(
        Icons.person,
        color: colorScheme.onSurfaceVariant,
        size: 22,
      ),
    );
  }
}

class _MoreMenuButton extends StatelessWidget {
  const _MoreMenuButton({required this.isHovered});
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Tooltip(
      message: 'خيارات',
      waitDuration: const Duration(milliseconds: 400),
      child: Material(
        type: MaterialType.transparency,
        child: InkResponse(
          onTap: () async {
            // Simple menu with common actions; wire up callbacks as needed.
            await showMenu<int>(
              context: context,
              position: const RelativeRect.fromLTRB(1, 1, 0, 0),
              items: [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.link_rounded, color: cs.onSurfaceVariant),
                      const SizedBox(width: 8),
                      const Text('نسخ الرابط'),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.flag_outlined, color: cs.onSurfaceVariant),
                      const SizedBox(width: 8),
                      const Text('إبلاغ'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.share_outlined, color: cs.onSurfaceVariant),
                      const SizedBox(width: 8),
                      const Text('مشاركة'),
                    ],
                  ),
                ),
              ],
            );
          },
          radius: 24,
          containedInkWell: true,
          customBorder: const CircleBorder(),
          splashColor: cs.primary.withOpacity(0.12),
          highlightColor: cs.primary.withOpacity(0.06),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isHovered
                  ? cs.surfaceContainerHighest.withValues(alpha: 0.8)
                  : Colors.transparent,
            ),
            child: Icon(
              Icons.more_horiz,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

