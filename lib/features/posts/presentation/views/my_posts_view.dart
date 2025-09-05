import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/l10n/app_localizations.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/my_posts/my_posts_cubit.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/my_posts/my_posts_state.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/my_posts_list.dart';
import 'package:tatbeeqi/features/posts/presentation/widgets/posts_feed_shimmer.dart';

class MyPostsView extends StatefulWidget {
  const MyPostsView({super.key});

  @override
  State<MyPostsView> createState() => _MyPostsViewState();
}

class _MyPostsViewState extends State<MyPostsView> {
  @override
  void initState() {
    super.initState();
    // Delay the fetch to ensure BlocProvider context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MyPostsCubit>().fetchMyPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myPosts),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: BlocBuilder<MyPostsCubit, MyPostsState>(
        builder: (context, state) {
          if (state is MyPostsLoading) {
            return const PostsFeedShimmer();
          } else if (state is MyPostsLoaded) {
            if (state.posts.isEmpty) {
              return _buildEmptyState(context);
            }
            return MyPostsList(
              posts: state.posts,
              hasReachedMax: state.hasReachedMax,
              isLoadingMore: state.isLoadingMore,
            );
          } else if (state is MyPostsError) {
            return _buildErrorState(context, state.message);
          }
          return _buildEmptyState(context);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.post_add_outlined,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد منشورات بعد',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'ابدأ بإنشاء منشورك الأول لمشاركة أفكارك مع المجتمع',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.add),
              label: const Text('إنشاء منشور'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'حدث خطأ',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => context.read<MyPostsCubit>().refreshPosts(),
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
