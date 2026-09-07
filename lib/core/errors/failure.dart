abstract class Failure implements Exception {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

String failureMessage(Object error, {required String fallback}) {
  return error is Failure ? error.message : fallback;
}
