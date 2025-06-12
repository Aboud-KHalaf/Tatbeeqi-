part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NotesEvent {
  final String courseId;

  const LoadNotes(this.courseId);

  @override
  List<Object> get props => [courseId];
}

class AddNoteEvent extends NotesEvent {
  final Note note;

  const AddNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNoteEvent extends NotesEvent {
  final Note note;

  const UpdateNoteEvent(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNoteEvent extends NotesEvent {
  final int noteId;
  final String courseId;

  const DeleteNoteEvent({required this.noteId, required this.courseId});

  @override
  List<Object> get props => [noteId, courseId];
}
