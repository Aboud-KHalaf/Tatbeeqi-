import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_event.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_state.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/create_post_bar.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_shimmer.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/create_post_bar_shimmer.dart';

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
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<PostsBloc, PostsState>(
          builder: (context, state) {
            if (state is PostsLoading) {
              return const PostsShimmerLoadingWidget();
            } else if (state is PostsLoaded) {
              return PostsListWidget(
                posts: state.posts,
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
            return const CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CreatePostBar(),
                ),
                SliverToBoxAdapter(
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

class PostsListWidget extends StatelessWidget {
  final List<Post> posts;
  const PostsListWidget({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<PostsBloc>().add(RefreshPostsEvent()),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: CreatePostBar(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => PostCard(post: posts[index]),
              childCount: posts.length,
            ),
          ),
        ],
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
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CreatePostBarShimmer(),
        ),
        PostsShimmerList(itemCount: 4),
      ],
    );
  }
}
