import 'package:tatbeeqi/features/references/domain/entities/reference.dart';

class ReferenceModel extends Reference {
  const ReferenceModel({
    required super.id,
    required super.courseId,
    required super.title,
    required super.url,
    required super.type,
  });

  factory ReferenceModel.fromJson(Map<String, dynamic> json) {
    return ReferenceModel(
      id: json['id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? '',
      title: json['title'],
      url: json['url'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // Note: course_id is stored as INT in DB. Here we keep String in domain; convert when writing.
      'course_id': int.tryParse(courseId) ?? courseId,
      'title': title,
      'url': url,
      'type': type,
    };
  }
}
