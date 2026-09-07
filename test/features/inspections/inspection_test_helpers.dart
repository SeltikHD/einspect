import 'package:einspect/features/inspections/data/models/inspection_model.dart';
import 'package:einspect/features/inspections/domain/entities/inspection_entity.dart';

InspectionEntity makeInspection({
  String clientId = 'client-1',
  String userId = 'user-1',
  String workOrderId = 'work-order-1',
  String? serverId,
  String? observation = 'Observacao operacional valida',
  String? condition = 'good',
  double? latitude = -23.5505,
  double? longitude = -46.6333,
  String? photoPath = '/documents/photo.jpg',
  InspectionStatus status = InspectionStatus.draft,
  String? failureReason,
  DateTime? capturedAt,
  DateTime? syncedAt,
}) {
  final createdAt = DateTime.utc(2026, 1, 1);
  return InspectionEntity(
    clientId: clientId,
    userId: userId,
    workOrderId: workOrderId,
    serverId: serverId,
    observation: observation,
    condition: condition,
    latitude: latitude,
    longitude: longitude,
    photoPath: photoPath,
    status: status,
    failureReason: failureReason,
    capturedAt: capturedAt,
    syncedAt: syncedAt,
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}

InspectionModel makeModel({
  String clientId = 'client-1',
  String userId = 'user-1',
  String workOrderId = 'work-order-1',
  String? serverId,
  String? observation = 'Observacao operacional valida',
  String? condition = 'good',
  double? latitude = -23.5505,
  double? longitude = -46.6333,
  String? photoPath = '/documents/photo.jpg',
  String status = 'draft',
  String? failureReason,
  DateTime? capturedAt,
  DateTime? syncedAt,
}) {
  return InspectionModel.fromEntity(
    makeInspection(
      clientId: clientId,
      userId: userId,
      workOrderId: workOrderId,
      serverId: serverId,
      observation: observation,
      condition: condition,
      latitude: latitude,
      longitude: longitude,
      photoPath: photoPath,
      status: InspectionStatus.fromString(status),
      failureReason: failureReason,
      capturedAt: capturedAt,
      syncedAt: syncedAt,
    ),
  );
}
