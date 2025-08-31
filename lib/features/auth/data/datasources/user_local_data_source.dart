import '../../domain/entities/user.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearUser();
}
