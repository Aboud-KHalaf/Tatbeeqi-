import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed/post_feed_event.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed/post_feed_state.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/screens/create_post_screen.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card.dart';

class PostsFeedScreen extends StatelessWidget {
  const PostsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<PostFeedBloc>()..add(FetchPostsRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Posts'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreatePostScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<PostFeedBloc, PostFeedState>(
          builder: (context, state) {
            if (state is PostFeedLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostFeedLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PostFeedBloc>().add(RefreshPostsRequested());
                },
                child: ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return PostCard(post: post);
                  },
                ),
              );
            } else if (state is PostFeedError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Welcome to Posts!'));
            }
          },
        ),
      ),
    );
  }
}
