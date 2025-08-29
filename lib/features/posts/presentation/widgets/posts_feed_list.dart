import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/post_feed/post_feed_event.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/animated_create_post_bar.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/no_posts_available.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';

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
  final ValueNotifier<double> _scrollOffset = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Update scroll offset for animation
    _scrollOffset.value = _scrollController.offset;

    // Load more posts logic
    if (_isBottom && !widget.hasReachedMax && !widget.isLoadingMore) {
      context.read<PostsBloc>().add(LoadMorePostsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8); // Trigger at 80% scroll
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return RefreshIndicator(
      onRefresh: () async => context.read<PostsBloc>().add(RefreshPostsEvent()),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: AnimatedCreatePostBar(scrollOffset: _scrollOffset),
          ),
          if (widget.posts.isEmpty)
            const SliverToBoxAdapter(
              child: NoPostsAvailableWidget(),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => PostCard(post: widget.posts[index]),
              childCount: widget.posts.length,
            ),
          ),
          if (widget.isLoadingMore)
            const SliverToBoxAdapter(
              child: _LoadingMorePosts(),
            ),
          // End of list indicator with Material 3 design
          if (widget.hasReachedMax && widget.posts.isNotEmpty)
            const SliverToBoxAdapter(
              child: _EndOfPostsList(),
            ),
        ],
      ),
    );
  }
}

class _LoadingMorePosts extends StatelessWidget {
  const _LoadingMorePosts();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.12),
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
            l10n.postsLoadingMorePosts,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _EndOfPostsList extends StatelessWidget {
  const _EndOfPostsList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
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
            l10n.postsEndReachedTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.postsEndReachedSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
