import 'package:dio/dio.dart';

import '../../domain/entities/user_entity.dart';
import '../models/login_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  // Consumes protected GET /auth/me to fetch authenticated technician profile
  Future<UserEntity> getCurrentUser();
}

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  const AuthRemoteDataSourceImpl({required this._dio});

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.data == null) {
        throw Exception('Empty response received from server');
      }

      return LoginResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final message = e.response?.data?['message'] as String?;
        throw Exception(message ?? 'Credenciais inválidas');
      }
      throw Exception('Network communication failure');
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');

      if (response.data == null) {
        throw Exception('User profile not found');
      }

      final data = response.data!;
      return UserEntity(
        id: data['id'] as String,
        name: data['name'] as String,
        email: data['email'] as String,
        role: data['role'] as String,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Session expired or unauthorized');
      }
      throw Exception('Failed to fetch user profile');
    }
  }
}
