import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/core/helpers/snack_bar_helper.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/my_posts/my_posts_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_action_buttons.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_categories.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_header.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_image_section.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_text.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';

class MyPostCard extends StatefulWidget {
  final Post post;

  const MyPostCard({super.key, required this.post});

  @override
  State<MyPostCard> createState() => _MyPostCardState();
}

class _MyPostCardState extends State<MyPostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
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
    _elevationAnimation = Tween<double>(
      begin: 1.0,
      end: 4.0,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.0),
              border:
                  Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: _elevationAnimation.value * 2,
                  offset: Offset(0, _elevationAnimation.value),
                ),
              ],
            ),
            child: MouseRegion(
              onEnter: (_) => _onHover(true),
              onExit: (_) => _onHover(false),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                onLongPress: () => _handleLongPress(context),
                onTap: () => _handleTap(context),
                onTapDown: (_) => _onTapDown(),
                onTapUp: (_) => _onTapUp(),
                onTapCancel: () => _onTapUp(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header with action menu
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(child: PostCardHeader(post: widget.post)),
                          _buildActionMenu(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.post.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: PostText(post: widget.post),
                      ),
                    if (widget.post.imageUrl != null &&
                        widget.post.imageUrl!.isNotEmpty)
                      PostImageSection(imageUrl: widget.post.imageUrl!),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: PostCardCategories(
                          categories: widget.post.categories),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      child: PostCardActionButtons(post: widget.post),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onHover(bool isHovered) {
    if (_isHovered != isHovered) {
      setState(() {
        _isHovered = isHovered;
      });
      if (isHovered) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _onTapDown() {
    HapticFeedback.selectionClick();
    _animationController.forward();
  }

  void _onTapUp() {
    if (!_isHovered) {
      _animationController.reverse();
    }
  }

  Widget _buildActionMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: colorScheme.onSurfaceVariant,
        size: 20,
      ),
      onSelected: (value) => _handleMenuAction(context, value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18, color: colorScheme.primary),
              const SizedBox(width: 12),
              Text(l10n.edit),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: colorScheme.error),
              const SizedBox(width: 12),
              Text(l10n.delete),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit':
        _showEditDialog(context);
        break;
      case 'delete':
        _showDeleteDialog(context);
        break;
    }
  }

  void _showEditDialog(BuildContext context) {
    context.push(
      AppRoutes.createOrEditPost,
      extra: CreateOrEditPostArgs(postToEdit: widget.post),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deletePost),
        content: Text(l10n.deletePostConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              context.read<MyPostsCubit>().deletePost(widget.post.id);
              Navigator.pop(dialogContext);
              SnackBarHelper.showSuccess(
                context: context,
                message: l10n.postDeleted,
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty) {
      context.push(
        AppRoutes.postDetails,
        extra: PostDetailsArgs(post: widget.post, showMore: false),
      );
    }
  }

  void _handleLongPress(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.mediumImpact();
    Clipboard.setData(ClipboardData(text: widget.post.text));
    SnackBarHelper.showInfo(
      context: context,
      message: l10n.postCardTextCopied,
    );
  }
}
