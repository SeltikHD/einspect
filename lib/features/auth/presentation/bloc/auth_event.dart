sealed class AuthEvent {
  const AuthEvent();
}

final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

final class AuthLoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginSubmitted({required this.email, required this.password});
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
