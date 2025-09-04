class AppNotification {
  // Supabase schema fields
  final String id; // uuid
  final String title;
  final String? body;
  final String? imageUrl;
  final String? html;
  final DateTime date; // server sent date
  final String? type; // e.g., 'user', 'system'
  final List<String>? targetUserIds; // uuid[]
  final List<String>? targetTopics; // text[]
  final String? sentBy; // uuid
  final DateTime? createdAt; // server created_at

  // Local-only helper
  final bool seen;

  const AppNotification({
    required this.id,
    required this.title,
    this.body,
    this.imageUrl,
    this.html,
    required this.date,
    this.type,
    this.targetUserIds,
    this.targetTopics,
    this.sentBy,
    this.createdAt,
    this.seen = false,
  });

  bool isValid() => title.isNotEmpty;

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? imageUrl,
    String? html,
    DateTime? date,
    String? type,
    List<String>? targetUserIds,
    List<String>? targetTopics,
    String? sentBy,
    DateTime? createdAt,
    bool? seen,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      html: html ?? this.html,
      date: date ?? this.date,
      type: type ?? this.type,
      targetUserIds: targetUserIds ?? this.targetUserIds,
      targetTopics: targetTopics ?? this.targetTopics,
      sentBy: sentBy ?? this.sentBy,
      createdAt: createdAt ?? this.createdAt,
      seen: seen ?? this.seen,
    );
  }
}
