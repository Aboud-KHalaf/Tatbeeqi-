import 'package:equatable/equatable.dart';

class Reference extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String url;
  final String type;

  const Reference({
    required this.id,
    required this.courseId,
    required this.title,
    required this.url,
    required this.type,
  });

  @override
  List<Object?> get props => [id, courseId, title, url, type];
}
