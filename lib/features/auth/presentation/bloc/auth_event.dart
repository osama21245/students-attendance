part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignUp(this.email, this.password, this.name);
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;

  AuthSignIn(
    this.email,
    this.password,
  );
}

class AuthIsUserLoggedIn extends AuthEvent {}
