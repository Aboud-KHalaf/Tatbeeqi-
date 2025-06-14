import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.studyYear,
    required super.department,
    required super.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      studyYear: map['study_year'] as int? ?? 1,
      department: map['department'] as int? ?? 1,
      email: map['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'study_year': studyYear,
      'department': department,
      'email': email,
    };
  }
}
