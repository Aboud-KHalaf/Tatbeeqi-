import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_event.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/comments_sheet.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class PostCardActionButtons extends StatefulWidget {
  final Post post;
  const PostCardActionButtons({super.key, required this.post});

  @override
  State<PostCardActionButtons> createState() => _PostCardActionButtonsState();
}

class _PostCardActionButtonsState extends State<PostCardActionButtons>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _likeAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _likeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 0.9)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_likeController);
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _handleLike() async {
    if (_isAnimating) return;

    _isAnimating = true;
    HapticFeedback.lightImpact();

    await _likeController.forward();
    _likeController.reset();
    _isAnimating = false;

    if (mounted) {
      context.read<PostsBloc>().add(LikePostToggledEvent(widget.post.id));
    }
  }

  void _showComments() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => CommentsSheet(post: widget.post),
    );
  }

  void _showShareSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ShareSheet(post: widget.post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _likeAnimation,
              builder: (context, child) => Transform.scale(
                scale: _likeAnimation.value,
                child: _ActionButton(
                  icon: widget.post.isLiked
                      ? Icons.thumb_up_rounded
                      : Icons.thumb_up_outlined,
                  label: _formatCount(widget.post.likesCount),
                  onPressed: _handleLike,
                  isActive: widget.post.isLiked,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionButton(
              icon: Icons.mode_comment_outlined,
              label: _formatCount(widget.post.commentsCount),
              onPressed: _showComments,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ActionButton(
              icon: Icons.share_outlined,
              label: l10n.postCardShare,
              onPressed: _showShareSheet,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final color = isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    final backgroundColor = isDark
        ? Colors.grey.shade800.withValues(alpha: 0.3)
        : Colors.grey.shade100.withValues(alpha: 0.8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareSheet extends StatelessWidget {
  final Post post;

  const _ShareSheet({required this.post});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.postCardSharePost,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.link_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(l10n.postCardCopyLink),
                  onTap: () {
                    Navigator.pop(context);
                    SnackBarHelper.showInfo(
                      context: context,
                      message: l10n.postCardLinkCopied,
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.share_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(l10n.postCardShareVia),
                  onTap: () => Navigator.pop(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
