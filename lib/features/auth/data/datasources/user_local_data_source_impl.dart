import 'package:hive/hive.dart';

import '../../domain/entities/user.dart';
import 'user_local_data_source.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final HiveInterface hive;
  static const String _userBoxName = 'user_box';
  static const String _userKey = 'current_user';

  UserLocalDataSourceImpl(this.hive);

  @override
  Future<void> saveUser(User user) async {
    final box = await hive.openBox<User>(_userBoxName);
    await box.put(_userKey, user);
  }

  @override
  Future<User?> getUser() async {
    final box = await hive.openBox<User>(_userBoxName);
    return box.get(_userKey);
  }

  @override
  Future<void> clearUser() async {
    final box = await hive.openBox<User>(_userBoxName);
    await box.delete(_userKey);
  }
}
