import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_event.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_state.dart';
import 'package:tatbeeqi/features/posts/presentation/views/create_post_view.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card.dart';

class PostsFeedView extends StatefulWidget {
  const PostsFeedView({super.key});

  @override
  State<PostsFeedView> createState() => _PostsFeedViewState();
}

class _PostsFeedViewState extends State<PostsFeedView> {
  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().add(FetchPostsEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(90.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreatePostView()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<PostsBloc, PostsState>(
              builder: (context, state) {
                if (state is PostsLoading) {
                  return const PostsShimmerLoadingWidget();
                } else if (state is PostsLoaded) {
                  return PostsListWidget(
                    posts: state.posts,
                  );
                } else if (state is PostsError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('Welcome to the Feed'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PostsListWidget extends StatelessWidget {
  final List<Post> posts;
  const PostsListWidget({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<PostsBloc>().add(RefreshPostsEvent()),
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (_, index) => PostCard(post: posts[index]),
      ),
    );
  }
}

class PostsShimmerLoadingWidget extends StatelessWidget {
  const PostsShimmerLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
