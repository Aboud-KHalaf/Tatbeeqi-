
import 'package:flutter/material.dart';

class CreatePostBar extends StatelessWidget {
  final VoidCallback onTap;
  const CreatePostBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    return Material(
      elevation: 8,
      shadowColor: Colors.black45,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00BCD4), Color(0xFF4DD0E1)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 44,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      'ابدأ منشورًا جديدًا',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.hintColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.add_photo_alternate_rounded,
                    color: theme.colorScheme.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
