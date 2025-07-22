import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/comments/comments_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/comments/comments_event.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/comments/comments_state.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_event.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/add_comment_bar.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/comment_tile_shimmer.dart';
import 'package:tatbeeqi/core/widgets/custom_error_widget.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/comments_empty_widget.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/comments_list_widget.dart';

class CommentsSheet extends StatefulWidget {
  final String postId;

  const CommentsSheet({super.key, required this.postId});

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  @override
  void initState() {
    super.initState();
    context.read<CommentsBloc>().add(FetchComments(widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.7,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Comments',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              // Comments List
              Expanded(
                child: BlocBuilder<CommentsBloc, CommentsState>(
                  builder: (context, state) {
                    if (state is CommentsLoading) {
                      return const CommentTaileShimmerList();
                    } else if (state is CommentsError) {
                      return CustomErrorWidget(
                        message: state.message,
                        postId: widget.postId,
                      );
                    } else if (state is CommentsLoaded) {
                      if (state.comments.isEmpty) {
                        return const CommentsEmptyWidget();
                      }

                      return CommentsListWidget(
                        comments: state.comments,
                        hasReachedMax: state.hasReachedMax,
                        isLoadingMore: state.isLoadingMore,
                        postId: widget.postId,
                        scrollController: scrollController,
                      );
                    }

                    return const CommentsEmptyWidget();
                  },
                ),
              ),

              // Add Comment Input
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: AddCommentBar(onSubmit: (text) {
                  context
                      .read<CommentsBloc>()
                      .add(AddComment(widget.postId, text));
                  context
                      .read<PostsBloc>()
                      .add(IncrementPostCommentCountEvent(widget.postId));
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

//
