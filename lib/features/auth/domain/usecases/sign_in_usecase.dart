import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;
  SignInUseCase(this._repository);

  Future<User> call({required String email, required String password}) {
    return _repository.signIn(email: email, password: password);
  }
}
