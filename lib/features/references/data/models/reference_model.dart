
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
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      url: json['url'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'url': url,
      'type': type,
    };
  }
}
