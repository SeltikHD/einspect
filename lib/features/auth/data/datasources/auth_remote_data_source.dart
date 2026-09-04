import 'package:dio/dio.dart';

import '../models/login_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({required this._dio});

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
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Empty response from server',
        );
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
}
