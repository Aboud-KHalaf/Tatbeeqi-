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

    final content = 
     Center(
      child: SingleChildScrollView(
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
              'مشكلة في الاتصال',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'تفقد اتصالك بالانترنت ثم حاول مرة اخرى',
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
                  onPressed:onAction,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 18,
                  ),
                  label: const Text('حاول مجددا'),
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
      ),
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
