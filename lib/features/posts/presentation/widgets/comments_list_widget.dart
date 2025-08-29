import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/comments/comments_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/comments/comments_event.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/comment_tile.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

class CommentsListWidget extends StatefulWidget {
  final List<Comment> comments;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String postId;
  final ScrollController scrollController;

  const CommentsListWidget({
    super.key,
    required this.comments,
    required this.hasReachedMax,
    required this.isLoadingMore,
    required this.postId,
    required this.scrollController,
  });

  @override
  State<CommentsListWidget> createState() => _CommentsListWidgetState();
}

class _CommentsListWidgetState extends State<CommentsListWidget> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom && !widget.hasReachedMax && !widget.isLoadingMore) {
      context.read<CommentsBloc>().add(LoadMoreComments(widget.postId));
    }
  }

  bool get _isBottom {
    if (!widget.scrollController.hasClients) return false;
    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Trigger at 90% scroll
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: widget.comments.length,
            itemBuilder: (context, index) {
              final comment = widget.comments[index];
              return CommentTile(comment: comment);
            },
          ),
        ),
        // Loading more indicator with Material 3 design
        if (widget.isLoadingMore)
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.commentsLoadingMore,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
