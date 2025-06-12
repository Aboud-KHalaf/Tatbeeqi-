import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final int? id;
  final String courseId;
  final String title;
  final String content;
  final DateTime lastModified;
  final int colorIndex;

  const Note({
    this.id,
    required this.courseId,
    required this.title,
    required this.content,
    required this.lastModified,
    this.colorIndex = 0,
  });

  Note copyWith({
    int? id,
    String? courseId,
    String? title,
    String? content,
    DateTime? lastModified,
    int? colorIndex,
  }) {
    return Note(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      content: content ?? this.content,
      lastModified: lastModified ?? this.lastModified,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  @override
  List<Object?> get props => [id, courseId, title, content, lastModified, colorIndex];
}
