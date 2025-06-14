import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class UpdateUserUseCase {
  final AuthRepository _repository;
  UpdateUserUseCase(this._repository);

  Future<User> call({
    String? name,
    int? studyYear,
    int? department,
    String? email,
    String? password,
  }) {
    return _repository.updateUser(
      name: name,
      studyYear: studyYear,
      department: department,
      email: email,
      password: password,
    );
  }
}
