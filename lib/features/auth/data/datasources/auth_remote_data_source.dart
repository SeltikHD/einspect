import 'package:dio/dio.dart';

import '../../domain/entities/user_entity.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

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
        throw Exception('Resposta vazia recebida do servidor');
      }

      return LoginResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final message = e.response?.data?['message'] as String?;
        throw Exception(message ?? 'Credenciais inválidas');
      }

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('Tempo limite de conexão esgotado. Verifique a API.');
        case DioExceptionType.connectionError:
          throw Exception(
            'Não foi possível conectar ao servidor. Verifique se o mock está rodando e a porta está configurada.',
          );
        default:
          throw Exception('Ocorreu um erro de comunicação inesperado.');
      }
    } catch (e) {
      throw Exception('Erro ao processar autenticação.');
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');

      if (response.data == null) {
        throw Exception('Perfil do usuário não encontrado');
      }

      return UserModel.fromJson(response.data!).toEntity();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sessão expirada ou não autorizado');
      }
      throw Exception('Falha ao buscar perfil do usuário');
    }
  }
}
