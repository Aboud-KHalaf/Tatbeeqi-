import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_event.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_state.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/animated_create_post_bar.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/posts_feed_list.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/posts_feed_shimmer.dart';

class PostsFeedView extends StatefulWidget {
  const PostsFeedView({super.key});

  @override
  State<PostsFeedView> createState() => _PostsFeedViewState();
}

class _PostsFeedViewState extends State<PostsFeedView> {
  @override
  void initState() {
    super.initState();
    //  context.read<PostsBloc>().add(FetchPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: SafeArea(
        child: BlocBuilder<PostsBloc, PostsState>(
          builder: (context, state) {
            if (state is PostsLoading) {
              return const PostsFeedShimmer();
            } else if (state is PostsLoaded) {
              return PostsListWidget(
                posts: state.posts,
                hasReachedMax: state.hasReachedMax,
                isLoadingMore: state.isLoadingMore,
              );
            } else if (state is PostsError) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  FilledButton(
                      onPressed: () async =>
                          context.read<PostsBloc>().add(RefreshPostsEvent()),
                      child: const Text("Try Again"))
                ],
              ));
            }
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AnimatedCreatePostBar(
                      scrollOffset: ValueNotifier<double>(0.0)),
                ),
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'Welcome to the Feed',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
