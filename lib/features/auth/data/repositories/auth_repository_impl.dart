import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote_auth_datasource.dart';
import '../datasources/user_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource _remote;
  final UserLocalDataSource _local;

  AuthRepositoryImpl({
    required RemoteAuthDataSource remote,
    required UserLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  @override
  Stream<User?> authStateChanges() => _remote.authStateChanges();

  @override
  Future<void> forgetPassword({required String email}) => _remote.forgetPassword(email: email);

  @override
  Future<User> signIn({required String email, required String password}) async {
    final user = await _remote.signIn(email: email, password: password);
    await _local.saveUser(user);
    return user;
  }

  @override
  Future<User> signInWithGoogle() async {
    final user = await _remote.signInWithGoogle();
    await _local.saveUser(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    await _remote.signOut();
    await _local.clearUser();
  }

  @override
  Future<User> signUp({
    required String name,
    required int studyYear,
    required int department,
    required String email,
    required String password,
  }) async {
    final user = await _remote.signUp(
      name: name,
      studyYear: studyYear,
      department: department,
      email: email,
      password: password,
    );
    await _local.saveUser(user);
    return user;
  }

  @override
  Future<User> updateUser({
    String? name,
    int? studyYear,
    int? department,
    String? email,
    String? password,
  }) async {
    final user = await _remote.updateUser(
      name: name,
      studyYear: studyYear,
      department: department,
      email: email,
      password: password,
    );
    await _local.saveUser(user);
    return user;
  }
}
