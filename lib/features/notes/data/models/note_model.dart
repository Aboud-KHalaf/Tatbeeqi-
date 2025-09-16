import 'package:tatbeeqi/core/services/database/tables/notes_table.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    super.id,
    required super.courseId,
    required super.title,
    required super.content,
    required super.lastModified,
    required super.colorIndex,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map[notesColId] as int?,
      courseId: map[notesColCourseId] as String,
      title: map[notesColTitle] as String,
      content: map[notesColContent] as String,
      lastModified: DateTime.parse(map[notesColLastModified] as String),
      colorIndex: map[notesColColor] as int? ?? 0,
    );
  }

  @override
  NoteModel copyWith({
    int? id,
    String? courseId,
    String? title,
    String? content,
    DateTime? lastModified,
    int? colorIndex,
  }) {
    return NoteModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      content: content ?? this.content,
      lastModified: lastModified ?? this.lastModified,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      notesColId: id,
      notesColCourseId: courseId,
      notesColTitle: title,
      notesColContent: content,
      notesColLastModified: lastModified.toIso8601String(),
      notesColColor: colorIndex,
    };
  }

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      courseId: note.courseId,
      title: note.title,
      content: note.content,
      lastModified: note.lastModified,
      colorIndex: note.colorIndex,
    );
  }
}
