part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String name;
  final int studyYear;
  final int department;
  final String email;
  final String password;
  SignUpEvent({
    required this.name,
    required this.studyYear,
    required this.department,
    required this.email,
    required this.password,
  });
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  SignInEvent({required this.email, required this.password});
}

class SignInWithGoogleEvent extends AuthEvent {}

class ForgetPasswordEvent extends AuthEvent {
  final String email;
  ForgetPasswordEvent(this.email);
}

class UpdateUserEvent extends AuthEvent {
  final String? name;
  final int? studyYear;
  final int? department;
  final String? email;
  final String? password;
  UpdateUserEvent({this.name, this.studyYear, this.department, this.email, this.password});
}

class SignOutEvent extends AuthEvent {}

class AuthStateChangedEvent extends AuthEvent {
  final User? user;
  AuthStateChangedEvent(this.user);
}
