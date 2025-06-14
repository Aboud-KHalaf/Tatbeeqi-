import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

abstract class RemoteAuthDataSource {
  Future<UserModel> signUp({
    required String name,
    required int studyYear,
    required int department,
    required String email,
    required String password,
  });

  Future<UserModel> signIn({required String email, required String password});

  Future<UserModel> signInWithGoogle();

  Future<void> forgetPassword({required String email});

  Future<UserModel> updateUser({
    String? name,
    int? studyYear,
    int? department,
    String? email,
    String? password,
  });

  Future<void> signOut();

  Stream<UserModel?> authStateChanges();
}

class RemoteAuthDataSourceImpl implements RemoteAuthDataSource {
  final SupabaseClient _supabase;
  RemoteAuthDataSourceImpl({required SupabaseClient supabaseClient}) : _supabase = supabaseClient;

  @override
  Stream<UserModel?> authStateChanges() {
    return _supabase.auth.onAuthStateChange.map((event) {
      final session = event.session;
      final user = session?.user;
      if (user == null) return null;
      final metadata = user.userMetadata;
      return UserModel(
        id: user.id,
        name: metadata?['name'] ?? '',
        studyYear: metadata?['study_year'] ?? 1,
        department: metadata?['department'] ?? 1,
        email: user.email ?? '',
      );
    });
  }

  @override
  Future<void> forgetPassword({required String email}) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    final response = await _supabase.auth.signInWithPassword(email: email, password: password);
    final user = response.user;
    if (user == null) throw AuthException('Unable to login');
    final metadata = user.userMetadata;
    return UserModel(
      id: user.id,
      name: metadata?['name'] ?? '',
      studyYear: metadata?['study_year'] ?? 1,
      department: metadata?['department'] ?? 1,
      email: user.email ?? '',
    );
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    await _supabase.auth.signInWithOAuth(OAuthProvider.google);
    final user = _supabase.auth.currentUser;
    if (user == null) throw AuthException('Google sign-in failed');
    final metadata = user.userMetadata;
    return UserModel(
      id: user.id,
      name: metadata?['name'] ?? '',
      studyYear: metadata?['study_year'] ?? 1,
      department: metadata?['department'] ?? 1,
      email: user.email ?? '',
    );
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required int studyYear,
    required int department,
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signUp(email: email, password: password, data: {
      'name': name,
      'study_year': studyYear,
      'department': department,
    });
    final user = response.user;
    if (user == null) throw AuthException('Unable to sign up');
    return UserModel(
      id: user.id,
      name: name,
      studyYear: studyYear,
      department: department,
      email: email,
    );
  }

  @override
  Future<UserModel> updateUser({
    String? name,
    int? studyYear,
    int? department,
    String? email,
    String? password,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw AuthException('Not logged in');

    final Map<String, dynamic> metadataUpdates = {};
    if (name != null) metadataUpdates['name'] = name;
    if (studyYear != null) metadataUpdates['study_year'] = studyYear;
    if (department != null) metadataUpdates['department'] = department;

    await _supabase.auth.updateUser(
      UserAttributes(
        email: email,
        password: password,
        data: metadataUpdates.isNotEmpty ? metadataUpdates : null,
      ),
    );

    final updatedUser = _supabase.auth.currentUser!;
    final metadata = updatedUser.userMetadata;
    return UserModel(
      id: updatedUser.id,
      name: metadata?['name'] ?? '',
      studyYear: metadata?['study_year'] ?? 1,
      department: metadata?['department'] ?? 1,
      email: updatedUser.email ?? '',
    );
  }
}
