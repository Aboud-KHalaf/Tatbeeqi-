import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/create_post_bar_shimmer.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/post_card_shimmer.dart';

class PostsFeedShimmer extends StatelessWidget {
  const PostsFeedShimmer({
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
