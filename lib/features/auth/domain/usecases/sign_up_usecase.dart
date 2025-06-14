
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  SignUpUseCase(this._repository);

  Future<User> call({
    required String name,
    required int studyYear,
    required int department,
    required String email,
    required String password,
  }) {
    return _repository.signUp(
      name: name,
      studyYear: studyYear,
      department: department,
      email: email,
      password: password,
    );
  }
}
