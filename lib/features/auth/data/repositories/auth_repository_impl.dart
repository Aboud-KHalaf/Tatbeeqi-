import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource _remote;
  AuthRepositoryImpl({required RemoteAuthDataSource remote}) : _remote = remote;

  @override
  Stream<User?> authStateChanges() => _remote.authStateChanges();

  @override
  Future<void> forgetPassword({required String email}) => _remote.forgetPassword(email: email);

  @override
  Future<User> signIn({required String email, required String password}) => _remote.signIn(email: email, password: password);

  @override
  Future<User> signInWithGoogle() => _remote.signInWithGoogle();

  @override
  Future<void> signOut() => _remote.signOut();

  @override
  Future<User> signUp({
    required String name,
    required int studyYear,
    required int department,
    required String email,
    required String password,
  }) => _remote.signUp(
        name: name,
        studyYear: studyYear,
        department: department,
        email: email,
        password: password,
      );

  @override
  Future<User> updateUser({
    String? name,
    int? studyYear,
    int? department,
    String? email,
    String? password,
  }) => _remote.updateUser(
        name: name,
        studyYear: studyYear,
        department: department,
        email: email,
        password: password,
      );
}
