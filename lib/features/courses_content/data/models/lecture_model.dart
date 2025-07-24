import '../../domain/entities/lecture_entity.dart';

class LectureModel extends Lecture {
  const LectureModel({
    required super.id,
    required super.courseId,
    required super.title,
    super.description,
    required super.orderIndex,
    // required super.lessons,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      description: json['description'],
      orderIndex: json['order_index'],
      // lessons: (json['lessons'] as List?)
      //         ?.map((lesson) => LessonModel.fromJson(lesson))
      //         .toList() ??
      //     [],
    );
  }
}
