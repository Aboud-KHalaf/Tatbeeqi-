import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  final String? message;
  final bool fullscreen;
  final double? size;

  const AppLoading({
    super.key,
    this.message,
    this.fullscreen = true,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size ?? 36,
          height: size ?? 36,
          child: CupertinoActivityIndicator(
            color: colorScheme.primary,
          ),
        ),
        if ((message ?? '').isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (!fullscreen) {
      return Center(child: content);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: content,
      ),
    );
  }
}

/// Sliver-friendly loading view for scrollable pages
class SliverAppLoading extends StatelessWidget {
  final String? message;
  const SliverAppLoading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: AppLoading(message: message),
    );
  }
}
