import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:tatbeeqi/features/notes/presentation/widgets/notes_list.dart';

class NotesView extends StatefulWidget {
  final Course course;

  const NotesView({super.key, required this.course});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  void initState() {
    print("course id ${widget.course.id}");
    super.initState();
    final currentState = context.read<NotesBloc>().state;
    if (currentState is! NotesLoaded || currentState.notes.isEmpty) {
      context.read<NotesBloc>().add(LoadNotes(widget.course.id.toString()));
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
              return const Center(child: Text('لا بوجد ملاحظات محفوظة بعد'));
            }
            return NotesList(notes: state.notes);
          } else if (state is NotesError) {
            return Center(child: Text('خطا: ${state.message}'));
          } else {
            return const Center(child: Text('اهلا'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(
            AppRoutes.addUpdateNotePath,
            extra: AddUpdateNoteArgs(courseId: widget.course.id.toString()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
