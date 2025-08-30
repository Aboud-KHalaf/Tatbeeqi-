import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final String title;
  final String? message;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData icon;
  final bool fullscreen;

  const AppError({
    super.key,
    this.title = 'حدث خطأ ما',
    this.message,
    this.actionText,
    this.onAction,
    this.icon = Icons.error_outline_rounded,
    this.fullscreen = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 36, color: colorScheme.error),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        if ((message ?? '').isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (onAction != null && (actionText ?? '').isNotEmpty) ...[
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: onAction,
            child: Text(actionText!),
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

/// Sliver-friendly error view for scrollable pages
class SliverAppError extends StatelessWidget {
  final String title;
  final String? message;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData icon;

  const SliverAppError({
    super.key,
    this.title = 'حدث خطأ ما',
    this.message,
    this.actionText,
    this.onAction,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: AppError(
        title: title,
        message: message,
        actionText: actionText,
        onAction: onAction,
        icon: icon,
      ),
    );
  }
}
