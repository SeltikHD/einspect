import 'package:orbytis_challenge/features/auth/domain/entities/auth_session_entity.dart';
import 'package:orbytis_challenge/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<AuthSessionEntity> login({
    required String email,
    required String password,
  });

  // Retrieves authenticated profile via GET /auth/me using persisted Bearer token
  Future<UserEntity> getCurrentUser();

  Future<bool> isAuthenticated();

  Future<void> logout();
}
