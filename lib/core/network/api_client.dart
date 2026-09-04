import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final FlutterSecureStorage _storage;
  final Dio _dio;

  static const String _tokenKey = 'accessToken';
  static const String _authHeaderKey = 'Authorization';
  static const String _defaultBaseUrl = 'http://localhost:3000';

  ApiClient({required this._storage, Dio? customDio, String? baseUrl})
    : _dio =
          customDio ??
          Dio(
            BaseOptions(
              baseUrl:
                  baseUrl ??
                  const String.fromEnvironment(
                    'API_BASE_URL',
                    defaultValue: _defaultBaseUrl,
                  ),
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: const {'Content-Type': 'application/json'},
            ),
          ) {
    _dio.interceptors.add(_createAuthInterceptor());
  }

  Dio get client => _dio;

  QueuedInterceptorsWrapper _createAuthInterceptor() {
    return QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip token attachment on public endpoints to prevent redundant I/O operations
        if (options.path.contains('/auth/login')) {
          return handler.next(options);
        }

        final token = await _storage.read(key: _tokenKey);

        if (token != null && token.isNotEmpty) {
          options.headers[_authHeaderKey] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onError: (error, handler) async {
        // Clear cached credentials when the server rejects authorization
        if (error.response?.statusCode == 401) {
          await _storage.delete(key: _tokenKey);
        }

        return handler.next(error);
      },
    );
  }
}
