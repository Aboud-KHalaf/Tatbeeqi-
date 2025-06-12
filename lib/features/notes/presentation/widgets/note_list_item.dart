import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Make sure this import path is correct and AppColors is defined
import 'package:tatbeeqi/core/utils/notes_colors.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteListItem({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<Color> currentNoteColors =
        isDarkMode ? AppColors.darkNoteColors : AppColors.lightNoteColors;

    return Card(
      color: currentNoteColors[note.colorIndex],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 👈 Allow dynamic height
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 6),
              if (note.content.trim().isNotEmpty)
                Text(
                  note.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.85),
                      ),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 15, color: colorScheme.outline),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat.yMMMd().format(note.lastModified),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
