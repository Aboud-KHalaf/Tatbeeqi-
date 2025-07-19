import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/utils/custom_snack_bar.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_event.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/comments_sheet.dart';

class PostCardActionButtons extends StatefulWidget {
  final Post post;
  const PostCardActionButtons({super.key, required this.post});

  @override
  State<PostCardActionButtons> createState() => _PostCardActionButtonsState();
}

class _PostCardActionButtonsState extends State<PostCardActionButtons>
    with TickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late AnimationController _bounceController;
  late Animation<double> _likeScaleAnimation;
  late Animation<double> _bounceAnimation;

  bool _isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _likeScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.elasticOut,
    ));

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onLikePressed() async {
    if (_isLikeAnimating) return;

    setState(() {
      _isLikeAnimating = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Trigger like animation
    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reverse().then((_) {
        setState(() {
          _isLikeAnimating = false;
        });
      });
    });

    // Trigger the BLoC event
    context.read<PostsBloc>().add(LikePostToggledEvent(widget.post.id));
  }

  void _onButtonPressed(VoidCallback onPressed) {
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
    HapticFeedback.selectionClick();
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Like Button
          Expanded(
            child: AnimatedBuilder(
              animation: _likeScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _likeScaleAnimation.value,
                  child: _enhancedActionButton(
                    context: context,
                    icon: widget.post.isLiked
                        ? Icons.thumb_up_rounded
                        : Icons.thumb_up_outlined,
                    label: _formatCount(widget.post.likesCount),
                    onPressed: _onLikePressed,
                    isActive: widget.post.isLiked,
                    activeColor: theme.colorScheme.primary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),

          // Comment Button
          Expanded(
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bounceAnimation.value,
                  child: _enhancedActionButton(
                    context: context,
                    icon: Icons.mode_comment_outlined,
                    label: _formatCount(widget.post.commentsCount),
                    onPressed: () => _onButtonPressed(() {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        useSafeArea: true,
                        builder: (_) => CommentsSheet(postId: widget.post.id),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),

          // Share Button
          Expanded(
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bounceAnimation.value,
                  child: _enhancedActionButton(
                    context: context,
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onPressed: () => _onButtonPressed(() {
                      _showShareOptions(context);
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _enhancedActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = false,
    Color? activeColor,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultColor = theme.colorScheme.onSurfaceVariant;
    final buttonColor =
        isActive ? activeColor ?? theme.colorScheme.primary : defaultColor;

    final defaultBackgroundColor = isDark
        ? Colors.grey.shade800.withOpacity(0.3)
        : Colors.grey.shade100.withOpacity(0.8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        splashColor:
            (activeColor ?? theme.colorScheme.primary).withOpacity(0.1),
        highlightColor:
            (activeColor ?? theme.colorScheme.primary).withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor ?? defaultBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: (activeColor ?? theme.colorScheme.primary)
                          .withOpacity(0.1),
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  icon,
                  key: ValueKey(icon),
                  size: 20,
                  color: buttonColor,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: theme.textTheme.labelMedium?.copyWith(
                        color: buttonColor,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 12,
                      ) ??
                      TextStyle(
                        color: buttonColor,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 12,
                      ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Share Post',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _shareOption(
                    context: context,
                    icon: Icons.link_rounded,
                    title: 'Copy Link',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement copy link
                      CustomSnackBar.showInfo(
                          context: context,
                          message: "Link copied to clipboard");
                    },
                  ),
                  _shareOption(
                    context: context,
                    icon: Icons.share_rounded,
                    title: 'Share via...',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement native share
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _shareOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
