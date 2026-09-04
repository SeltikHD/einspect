import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

final class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'accessToken';

  const AuthLocalDataSourceImpl({required this._storage});

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
