import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signUp({
    required String name,
    required int studyYear,
    required int department,
    required String email,
    required String password,
  });

  Future<User> signIn({required String email, required String password});

  Future<User> signInWithGoogle();

  Future<void> forgetPassword({required String email});

  Future<User> updateUser({
    String? name,
    int? studyYear,
    int? department,
    String? email,
    String? password,
  });

  Future<void> signOut();

  Stream<User?> authStateChanges();

  Future<User?> getCurrentUser();
}
