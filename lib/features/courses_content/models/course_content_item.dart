import 'package:flutter/material.dart';

enum ContentType { video, assignment, reading, quiz }

class CourseContentItem {
  final String id;
  final String title;
  final ContentType type;
  final int durationMinutes;
  final bool isCompleted;
  final bool isDownloadable;
  final String? downloadSize;
  final IconData icon;

  CourseContentItem({
    required this.id,
    required this.title,
    required this.type,
    required this.durationMinutes,
    this.isCompleted = false,
    this.isDownloadable = true,
    this.downloadSize,
    IconData? icon,
  }) : icon = icon ?? _getDefaultIcon(type);

  static IconData _getDefaultIcon(ContentType type) {
    switch (type) {
      case ContentType.video:
        return Icons.play_circle_outline;
      case ContentType.assignment:
        return Icons.assignment;
      case ContentType.reading:
        return Icons.menu_book;
      case ContentType.quiz:
        return Icons.quiz;
    }
  }

  CourseContentItem copyWith({
    String? id,
    String? title,
    ContentType? type,
    int? durationMinutes,
    bool? isCompleted,
    bool? isDownloadable,
    String? downloadSize,
    IconData? icon,
  }) {
    return CourseContentItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      isDownloadable: isDownloadable ?? this.isDownloadable,
      downloadSize: downloadSize ?? this.downloadSize,
      icon: icon ?? this.icon,
    );
  }
}

class Module {
  final String id;
  final String title;
  final int moduleNumber;
  final bool isActive;
  final bool isCompleted;
  final List<CourseContentItem> contentItems;

  const Module({
    required this.id,
    required this.title,
    required this.moduleNumber,
    this.isActive = false,
    this.isCompleted = false,
    required this.contentItems,
  });

  double get completionPercentage {
    if (contentItems.isEmpty) return 0.0;
    final completedItems =
        contentItems.where((item) => item.isCompleted).length;
    return completedItems / contentItems.length;
  }
}
