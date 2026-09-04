import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

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
    final session = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    await _localDataSource.saveToken(session.accessToken);
    return session;
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
