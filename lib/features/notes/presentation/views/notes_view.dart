import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';
import 'package:tatbeeqi/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:tatbeeqi/features/notes/presentation/widgets/notes_list.dart';

class NotesView extends StatefulWidget {
  static const String routePath = '/notesView';

  final int courseId;

  const NotesView({super.key, required this.courseId});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  void initState() {
    super.initState();
    final currentState = context.read<NotesBloc>().state;
    if (currentState is! NotesLoaded || currentState.notes.isEmpty) {
      context.read<NotesBloc>().add(LoadNotes(widget.courseId.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotesLoaded) {
            if (state.notes.isEmpty) {
              return const Center(child: Text('No notes yet. Add one!'));
            }
            return NotesList(notes: state.notes);
          } else if (state is NotesError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Welcome to Notes!'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(
            AppRoutes.addUpdateNotePath,
            extra: AddUpdateNoteArgs(courseId: widget.courseId.toString()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
