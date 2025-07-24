import 'package:flutter/material.dart';
import 'package:tatbeeqi/features/courses_content/presentation/course_content_item.dart';
import 'package:tatbeeqi/features/home/domain/entities/course_item_entity.dart';

/// ---- ////

final List<CourseItementity> courses = [
  CourseItementity(
      title: 'بيانات حاسوب',
      iconPath: 'assets/images/coding.png',
      color: Colors.blueAccent), // Computer Data
  CourseItementity(
      title: 'أمن المعلومات',
      iconPath: 'assets/images/coding.png',
      color: Colors.redAccent), // Information Security
  CourseItementity(
      title: 'ادارة شبكات 2',
      iconPath: 'assets/images/coding.png',
      color: Colors.greenAccent), // Network Admin 2
  CourseItementity(
      title: 'أمن سيبراني',
      iconPath: 'assets/images/coding.png',
      color: Colors.orangeAccent), // Cyber Security
];

/// ---- ////

// Sample data
final List<CourseContentItem> contentItems = [
  CourseContentItem(
    id: '1',
    title: 'نظرة عامة على خدمات الواجهة الخلفية لتطبيقات الجوال',
    type: ContentType.video,
    durationMinutes: 6,
    isCompleted: true,
  ),
  CourseContentItem(
    id: '2',
    title: 'مقدمة في خدمات الواجهة الخلفية السحابية لتطبيقات الجوال',
    type: ContentType.video,
    durationMinutes: 8,
    isCompleted: true,
  ),
  CourseContentItem(
    id: '3',
    title: 'استراتيجيات نشر الواجهة الخلفية لتطبيقات الجوال',
    type: ContentType.video,
    durationMinutes: 8,
    isCompleted: true,
  ),
  CourseContentItem(
    id: '4',
    title: 'تطبيق عملي: نشر واجهة برمجية إلى السحابة باستخدام React Native',
    type: ContentType.assignment,
    durationMinutes: 30,
    isCompleted: true,
  ),
  CourseContentItem(
    id: '5',
    title: 'تطبيق عملي: نشر واجهة برمجية إلى السحابة باستخدام Flutter',
    type: ContentType.assignment,
    durationMinutes: 30,
    isCompleted: true,
  ),
  CourseContentItem(
    id: '6',
    title: 'مقدمة في قواعد البيانات المدمجة',
    type: ContentType.video,
    durationMinutes: 8,
    isCompleted: false,
  ),
  CourseContentItem(
    id: '7',
    title: 'SQLite في تطبيقات الجوال',
    type: ContentType.video,
    durationMinutes: 10,
    isCompleted: false,
  ),
  CourseContentItem(
    id: '8',
    title: 'تطبيق عملي: تنفيذ SQLite في Flutter',
    type: ContentType.assignment,
    durationMinutes: 45,
    isCompleted: false,
  ),
];
