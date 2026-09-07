import 'package:dio/dio.dart';

import '../../../../core/errors/failure.dart';
import '../models/work_order_model.dart';

abstract interface class WorkOrdersRemoteDataSource {
  Future<List<WorkOrderModel>> getWorkOrders({String? status});
}

final class WorkOrdersRemoteDataSourceImpl
    implements WorkOrdersRemoteDataSource {
  final Dio _dio;

  const WorkOrdersRemoteDataSourceImpl({required this._dio});

  @override
  Future<List<WorkOrderModel>> getWorkOrders({String? status}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/work-orders',
        queryParameters: status != null ? {'status': status} : null,
      );

      final data = response.data;
      if (data == null) return [];

      return data
          .map((item) => WorkOrderModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthenticationFailure(
          'Sessão expirada. Faça login novamente.',
        );
      }
      throw const NetworkFailure(
        'Falha ao sincronizar ordens de serviço remotas.',
      );
    }
  }
}
