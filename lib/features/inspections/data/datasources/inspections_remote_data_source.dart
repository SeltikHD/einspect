import 'package:dio/dio.dart';

import 'package:orbytis_challenge/core/errors/failure.dart';
import 'package:orbytis_challenge/features/inspections/data/models/inspection_model.dart';

abstract interface class InspectionsRemoteDataSource {
  /// Uploads inspection evidence to POST /inspections using multipart/form-data.
  Future<Map<String, dynamic>> uploadInspection(InspectionModel inspection);
}

final class InspectionsRemoteDataSourceImpl
    implements InspectionsRemoteDataSource {
  final Dio _dio;

  const InspectionsRemoteDataSourceImpl({required this._dio});

  @override
  Future<Map<String, dynamic>> uploadInspection(
    InspectionModel inspection,
  ) async {
    try {
      final file = await MultipartFile.fromFile(
        inspection.photoPath!,
        filename: '${inspection.clientId}.jpg',
      );

      // Construct multipart payload according to API specification
      final formData = FormData.fromMap({
        'clientId': inspection.clientId,
        'workOrderId': inspection.workOrderId,
        'observation': inspection.observation,
        if (inspection.condition != null) 'condition': inspection.condition,
        'latitude': inspection.latitude,
        'longitude': inspection.longitude,
        'capturedAt': inspection.capturedAt?.toIso8601String(),
        'photo': file,
      });

      final response = await _dio.post<Map<String, dynamic>>(
        '/inspections',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.data == null) {
        throw const NetworkFailure('Resposta vazia recebida do servidor.');
      }

      return response.data!;
    } on DioException catch (e) {
      // Unpack validation feedback returned from the backend (e.g., character length restrictions)
      if (e.response?.statusCode == 400) {
        final errorPayload = e.response?.data?['errors'];
        throw ValidationFailure(
          errorPayload?.toString() ?? 'Dados de inspeção inválidos',
        );
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkFailure('Sem conexão com o servidor para envio.');
      }

      throw NetworkFailure(
        e.message ?? 'Falha de comunicação no envio da inspeção.',
      );
    }
  }
}
