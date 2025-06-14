class User {
  final String id;
  final String name;
  final int studyYear; // 1..4  (maps to years.id)
  final int department; // 1 or 2 (maps to departments.department_id)
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.studyYear,
    required this.department,
    required this.email,
  });

  User copyWith({
    String? name,
    int? studyYear,
    int? department,
    String? email,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      studyYear: studyYear ?? this.studyYear,
      department: department ?? this.department,
      email: email ?? this.email,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.studyYear == studyYear &&
        other.department == department &&
        other.email == email;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ studyYear.hashCode ^ department.hashCode ^ email.hashCode;
}
