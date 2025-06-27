import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed/post_feed_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed/post_feed_event.dart';
import 'package:tatbeeqi/features/posts/presentation/bloc/post_feed/post_feed_state.dart';
import 'package:tatbeeqi/features/posts/presentation/screens/create_post_screen.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/create_post_bar.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card.dart';

class PostsFeedScreen extends StatefulWidget {
  const PostsFeedScreen({super.key});

  @override
  State<PostsFeedScreen> createState() => _PostsFeedScreenState();
}

class _PostsFeedScreenState extends State<PostsFeedScreen> {
  final _scrollController = ScrollController();
  static const double _threshold = 120;
  static const double _barHeight = 72;
  bool _showCreateBar = true;               // مرئيّ افتراضياً

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset <= _threshold;
    if (shouldShow != _showCreateBar) {
      setState(() => _showCreateBar = shouldShow);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<PostFeedBloc>()..add(FetchPostsRequested()),
      child: Scaffold(
        appBar: AppBar(title: const Text('المنشورات')),
        body: Stack(
          children: [
            // ---------------- قائمة المنشورات ----------------
            BlocBuilder<PostFeedBloc, PostFeedState>(
              builder: (context, state) {
                if (state is PostFeedLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PostFeedLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async =>
                        context.read<PostFeedBloc>().add(RefreshPostsRequested()),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                          top: _showCreateBar ? _barHeight + 8 : 8),
                      itemCount: state.posts.length,
                      itemBuilder: (_, i) => PostCard(post: state.posts[i]),
                    ),
                  );
                } else if (state is PostFeedError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('مرحباً بك في المنشورات'));
              },
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              top: _showCreateBar ? 0 : -_barHeight,
              left: 0,
              right: 0,
              height: _barHeight,
              child: CreatePostBar(onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreatePostScreen()),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}