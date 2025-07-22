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

class PostsListWidget extends StatefulWidget {
  final List<Post> posts;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const PostsListWidget({
    super.key,
    required this.posts,
    required this.hasReachedMax,
    required this.isLoadingMore,
  });

  @override
  State<PostsListWidget> createState() => _PostsListWidgetState();
}

class _PostsListWidgetState extends State<PostsListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !widget.hasReachedMax && !widget.isLoadingMore) {
      context.read<PostsBloc>().add(LoadMorePostsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Trigger at 90% scroll
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<PostsBloc>().add(RefreshPostsEvent()),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverToBoxAdapter(
            child: CreatePostBar(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => PostCard(post: widget.posts[index]),
              childCount: widget.posts.length,
            ),
          ),
          // Loading more indicator with Material 3 design
          if (widget.isLoadingMore)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 16.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Loading more posts...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          // End of list indicator with Material 3 design
          if (widget.hasReachedMax && widget.posts.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 16.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.08),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You\'re all caught up!',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'No more posts to load',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
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
