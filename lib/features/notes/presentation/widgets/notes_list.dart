import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';
import 'package:tatbeeqi/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:tatbeeqi/features/notes/presentation/widgets/note_list_item.dart';
import 'package:tatbeeqi/features/notes/presentation/views/add_update_note_view.dart';

class NotesList extends StatelessWidget {
  final List<Note> notes;

  const NotesList({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.note_alt_outlined,
                size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'No notes yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first note.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: MasonryGridView.count(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteListItem(
            note: note,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddOrUpdateNoteView(
                    note: note,
                    courseId: note.courseId,
                  ),
                ),
              );
            },
            onDelete: () {
              context.read<NotesBloc>().add(
                  DeleteNoteEvent(noteId: note.id!, courseId: note.courseId));
            },
          );
        },
      ),
    );
  }
}
