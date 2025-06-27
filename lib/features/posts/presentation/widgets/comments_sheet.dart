import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comments/comments_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comments/comments_event.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comments/comments_state.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/comment_tile.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/add_comment_bar.dart';

class CommentsSheet extends StatelessWidget {
  final String postId;

  const CommentsSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<CommentsBloc>()..add(FetchCommentsRequested(postId)),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.comment, color: Theme.of(context).colorScheme.primary, size: 26),
                        const SizedBox(width: 8),
                        Text(
                          'التعليقات',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade300),
                  Expanded(
                    child: BlocBuilder<CommentsBloc, CommentsState>(
                      builder: (context, state) {
                        if (state is CommentsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is CommentsLoaded) {
                          if (state.comments.isEmpty) {
                            return const Center(child: Text('No comments yet.'));
                          }
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: state.comments.length,
                            itemBuilder: (context, index) {
                              final comment = state.comments[index];
                              return CommentTile(comment: comment);
                            },
                          );
                        } else if (state is CommentsError) {
                          return Center(child: Text(state.message));
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade200),
                  Material(
                    elevation: 2,
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 8, right: 8,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 6,
                        top: 4,
                      ),
                      child: AddCommentBar(onSubmit: (text) {
                        // TODO: Implement comment submission logic here
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
