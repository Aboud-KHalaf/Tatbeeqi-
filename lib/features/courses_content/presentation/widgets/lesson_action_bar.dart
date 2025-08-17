import 'package:flutter/material.dart';

class LessonActionBar extends StatelessWidget {
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback onAddNote;
  final VoidCallback onAskAi;

  const LessonActionBar({
    super.key,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.onAddNote,
    required this.onAskAi,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildCompactNavButton(
              context: context,
              icon: Icons.arrow_back,
              onPressed: canGoPrevious ? onPrevious : null,
            ),
            const SizedBox(width: 8),
            _buildCompactNavButton(
              context: context,
              icon: Icons.arrow_forward,
              onPressed: canGoNext ? onNext : null,
            ),
            const Spacer(),
            _buildFloatingActionButton(
              context: context,
              icon: Icons.note_add,
              onPressed: onAddNote,
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: 8),
            _buildFloatingActionButton(
              context: context,
              icon: Icons.psychology,
              onPressed: onAskAi,
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactNavButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = onPressed != null;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isEnabled
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerHigh.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled
              ? colorScheme.outline.withOpacity(0.2)
              : colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 20,
          color: isEnabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withOpacity(0.38),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildFloatingActionButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 22,
          color: foregroundColor,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
