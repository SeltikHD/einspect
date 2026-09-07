import 'package:orbytis_challenge/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:orbytis_challenge/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:orbytis_challenge/features/auth/domain/entities/auth_session_entity.dart';
import 'package:orbytis_challenge/features/auth/domain/entities/user_entity.dart';
import 'package:orbytis_challenge/features/auth/domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  const AuthRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
  });

  @override
  Future<AuthSessionEntity> login({
    required String email,
    required String password,
  }) async {
    final model = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    // Securely cache JWT for downstream interceptors
    await _localDataSource.saveToken(model.accessToken);
    return model.toEntity();
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    // Interceptor automatically injects the stored Bearer token into headers
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearToken();
  }
}
