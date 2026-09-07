import 'package:einspect/features/auth/domain/entities/user_entity.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated({required this.user});
}

final class Unauthenticated extends AuthState {
  final String? errorMessage;

  const Unauthenticated({this.errorMessage});
}
