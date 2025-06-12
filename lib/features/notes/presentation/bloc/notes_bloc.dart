import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';
import 'package:tatbeeqi/features/notes/domain/usecases/add_note.dart';
import 'package:tatbeeqi/features/notes/domain/usecases/delete_note.dart';
import 'package:tatbeeqi/features/notes/domain/usecases/get_notes_by_course_id.dart';
import 'package:tatbeeqi/features/notes/domain/usecases/update_note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetNotesByCourseId getNotesByCourseId;
  final AddNote addNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;

  NotesBloc({
    required this.getNotesByCourseId,
    required this.addNote,
    required this.updateNote,
    required this.deleteNote,
  }) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);

    on<AddNoteEvent>((event, emit) async {
      final newNote = event.note.copyWith(lastModified: DateTime.now());
      final result = await addNote(newNote);
      result.fold(
        (failure) => emit(NotesError(failure.message)),
        (_) => add(LoadNotes(event.note.courseId)),
      );
    });

    on<UpdateNoteEvent>((event, emit) async {
      final updatedNote = event.note.copyWith(lastModified: DateTime.now());
      final result = await updateNote(updatedNote);
      result.fold(
        (failure) => emit(NotesError(failure.message)),
        (_) => add(LoadNotes(event.note.courseId)),
      );
    });

    on<DeleteNoteEvent>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    final result = await getNotesByCourseId(event.courseId);
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (notes) => emit(NotesLoaded(notes)),
    );
  }

  Future<void> _onDeleteNote(
      DeleteNoteEvent event, Emitter<NotesState> emit) async {
    final result = await deleteNote(event.noteId);
    result.fold(
      (failure) => emit(NotesError(failure.message)),
      (_) => add(LoadNotes(event.courseId)),
    );
  }
}
