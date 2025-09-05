import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/my_posts/my_posts_cubit.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/my_post_card.dart';

class MyPostsList extends StatefulWidget {
  final List<Post> posts;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const MyPostsList({
    super.key,
    required this.posts,
    required this.hasReachedMax,
    required this.isLoadingMore,
  });

  @override
  State<MyPostsList> createState() => _MyPostsListState();
}

class _MyPostsListState extends State<MyPostsList>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  final List<AnimationController> _itemAnimationControllers = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _initializeItemAnimations();
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    for (final controller in _itemAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeItemAnimations() {
    _itemAnimationControllers.clear();
    for (int i = 0; i < widget.posts.length; i++) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 300 + (i * 50)),
        vsync: this,
      );
      _itemAnimationControllers.add(controller);
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          controller.forward();
        }
      });
    }
  }

  void _onScroll() {
    if (_isBottom && !widget.hasReachedMax && !widget.isLoadingMore) {
      context.read<MyPostsCubit>().loadMorePosts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<MyPostsCubit>().refreshPosts();
        _initializeItemAnimations();
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: widget.posts.length + (widget.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= widget.posts.length) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            );
          }

          if (index < _itemAnimationControllers.length) {
            return AnimatedBuilder(
              animation: _itemAnimationControllers[index],
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    30 * (1 - _itemAnimationControllers[index].value),
                  ),
                  child: Opacity(
                    opacity: _itemAnimationControllers[index].value,
                    child: MyPostCard(post: widget.posts[index]),
                  ),
                );
              },
            );
          }

          return MyPostCard(post: widget.posts[index]);
        },
      ),
    );
  }
}
