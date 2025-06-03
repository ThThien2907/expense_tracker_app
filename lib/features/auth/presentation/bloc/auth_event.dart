part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String language;

  AuthSignUp({
    required this.email,
    required this.password,
    required this.fullName,
    required this.language,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthLoginWithGoogle extends AuthEvent {
  final String language;

  AuthLoginWithGoogle({
    required this.language,
  });
}

final class AuthLoggedIn extends AuthEvent {}
