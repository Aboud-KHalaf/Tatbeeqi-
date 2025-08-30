part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

// Granular loading states for different operations
class AuthLoading extends AuthState {
  final AuthOperation operation;
  AuthLoading(this.operation);
}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final AuthOperation? operation;
  AuthError(this.message, {this.operation});
}

// Success states for specific operations
class AuthOperationSuccess extends AuthState {
  final AuthOperation operation;
  final String? message;
  AuthOperationSuccess(this.operation, {this.message});
}

// Enum to track which operation is loading
enum AuthOperation {
  signIn,
  signUp,
  signInWithGoogle,
  forgetPassword,
  updateProfile,
  signOut,
}
