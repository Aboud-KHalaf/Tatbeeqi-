import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comments/comments_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comments/comments_event.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comments/comments_state.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed/post_feed_event.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/comment_tile.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/add_comment_bar.dart';

class CommentsSheet extends StatelessWidget {
  final String postId;

  const CommentsSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (context) =>
          GetIt.instance<CommentsBloc>()..add(FetchComments(postId)),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border:
                  Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
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
                const Divider(height: 1),
                // Comments List
                Expanded(
                  child: BlocBuilder<CommentsBloc, CommentsState>(
                    builder: (context, state) {
                      final comments =
                          state is CommentsLoaded ? state.comments : [];

                      if (state is CommentsLoading && comments.isEmpty) {
                        // 🔁 Only show loading when it's the initial fetch
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CommentsError) {
                        return Center(child: Text(state.message));
                      } else if (comments.isEmpty) {
                        return const Center(
                            child: Text('Be the first to comment!'));
                      }

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return CommentTile(comment: comment);
                        },
                      );
                    },
                  ),
                ),

                // Add Comment Input
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(height: 1),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: AddCommentBar(onSubmit: (text) {
                        context
                            .read<CommentsBloc>()
                            .add(AddComment(postId, text));
                        context
                            .read<PostsBloc>()
                            .add(IncrementPostCommentCount(postId));
                      }),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
