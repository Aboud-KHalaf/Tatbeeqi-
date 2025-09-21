import 'dart:io';
import 'package:tatbeeqi/features/courses/domain/entities/course_entity.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lecture_entity.dart';
import 'package:tatbeeqi/features/courses_content/domain/entities/lesson_entity.dart';
import 'package:tatbeeqi/features/news/domain/entities/news_item_entity.dart';
import 'package:tatbeeqi/features/notes/domain/entities/note.dart';
import 'package:tatbeeqi/features/quiz/domain/entities/quiz_question.dart';
import 'package:tatbeeqi/features/posts/domain/entities/post.dart';

class NewsDetailsArgs {
  final NewsItemEntity newsItem;
  final String heroTag;

  NewsDetailsArgs({
    required this.newsItem,
    required this.heroTag,
  });
}

class AddUpdateNoteArgs {
  final Note? note;
  final String courseId;

  AddUpdateNoteArgs({this.note, required this.courseId});
}

class QuizResultArgs {
  final int score;
  final Map<String, bool> results;
  final List<QuizQuestion> questions;
  final Map<String, String> userAnswers;

  QuizResultArgs(
      {required this.score,
      required this.results,
      required this.questions,
      required this.userAnswers});
}

class CourseOverviewArgs {
  final Course course;
  CourseOverviewArgs({required this.course});
}

class LectureLessonsArgs {
  final Course course;
  final Lecture lecture;
  LectureLessonsArgs({required this.lecture, required this.course});
}

class LessonContentArgs {
  final List<Lesson> lesson;
  final int index;
  final int courseId;
  LessonContentArgs(
      {required this.lesson, required this.index, required this.courseId});
}

class PostDetailsArgs {
  final Post post;
  final bool showMore;

  PostDetailsArgs({required this.post, this.showMore = true});
}

class CreateOrEditPostArgs {
  final Post? postToEdit;
  final File? imageFile;
  final bool? isArticle;

  CreateOrEditPostArgs({this.postToEdit, this.imageFile, this.isArticle});
}
