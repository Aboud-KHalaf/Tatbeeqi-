import '../repositories/auth_repository.dart';

class ForgetPasswordUseCase {
  final AuthRepository _repository;
  ForgetPasswordUseCase(this._repository);

  Future<void> call({required String email}) => _repository.forgetPassword(email: email);
}
