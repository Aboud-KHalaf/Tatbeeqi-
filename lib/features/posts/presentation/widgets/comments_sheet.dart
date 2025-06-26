import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/posts/domain/entities/comment.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comments/comments_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comments/comments_event.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/comments/comments_state.dart';

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
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Comments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
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
                          return _CommentTile(comment: comment);
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
              _AddCommentBar(),
            ],
          );
        },
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final Comment comment;

  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch author details (name, avatar) using authorId for a richer UI.
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${comment.authorId}'),
      ),
      title: Text(comment.authorId), // Using authorId as a placeholder for name
      subtitle: Text(comment.text),
    );
  }
}

class _AddCommentBar extends StatelessWidget {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              // TODO: Implement add comment logic
            },
          ),
        ],
      ),
    );
  }
}
