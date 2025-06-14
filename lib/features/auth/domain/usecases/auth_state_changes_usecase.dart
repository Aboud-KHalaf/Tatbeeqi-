import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class AuthStateChangesUseCase {
  final AuthRepository _repository;
  AuthStateChangesUseCase(this._repository);

  Stream<User?> call() => _repository.authStateChanges();
}
