import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/comments/comments_bloc.dart';
import 'package:tatbeeqi/features/posts/presentation/manager/comments/comments_event.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String postId;

  const CustomErrorWidget({
    super.key,
    required this.message,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: colorScheme.error.withValues(alpha: 0.2),
                  width: 1,
                )),
            child: Icon(
              Icons.wifi_off_rounded,
              size: 32,
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Connection Problem',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check your internet connection\nand try again',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  context.read<CommentsBloc>().add(RefreshComments(postId));
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                ),
                label: const Text('Try Again'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(
                    color: colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
