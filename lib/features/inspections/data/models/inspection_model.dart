import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/database/tables/inspections_table.dart';
import '../../domain/entities/inspection_entity.dart';

part 'inspection_model.freezed.dart';
part 'inspection_model.g.dart';

@freezed
abstract class InspectionModel with _$InspectionModel {
  const InspectionModel._();

  const factory InspectionModel({
    required String clientId,
    required String userId,
    required String workOrderId,
    String? serverId,
    String? observation,
    String? condition,
    double? latitude,
    double? longitude,
    String? photoPath,
    @Default('draft') String status,
    String? failureReason,
    DateTime? capturedAt,
    DateTime? syncedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _InspectionModel;

  factory InspectionModel.fromJson(Map<String, dynamic> json) =>
      _$InspectionModelFromJson(json);

  /// Reconstitutes the model from SQLite database columns.
  factory InspectionModel.fromDatabase(Map<String, dynamic> map) {
    return InspectionModel(
      clientId: map[InspectionsTable.columnClientId] as String,
      userId: map[InspectionsTable.columnUserId] as String,
      workOrderId: map[InspectionsTable.columnWorkOrderId] as String,
      serverId: map[InspectionsTable.columnServerId] as String?,
      observation: map[InspectionsTable.columnObservation] as String?,
      condition: map[InspectionsTable.columnCondition] as String?,
      latitude: (map[InspectionsTable.columnLatitude] as num?)?.toDouble(),
      longitude: (map[InspectionsTable.columnLongitude] as num?)?.toDouble(),
      photoPath: map[InspectionsTable.columnPhotoPath] as String?,
      status: map[InspectionsTable.columnStatus] as String,
      failureReason: map[InspectionsTable.columnFailureReason] as String?,
      capturedAt: map[InspectionsTable.columnCapturedAt] != null
          ? DateTime.parse(map[InspectionsTable.columnCapturedAt] as String)
          : null,
      syncedAt: map[InspectionsTable.columnSyncedAt] != null
          ? DateTime.parse(map[InspectionsTable.columnSyncedAt] as String)
          : null,
      createdAt: DateTime.parse(
        map[InspectionsTable.columnCreatedAt] as String,
      ),
      updatedAt: DateTime.parse(
        map[InspectionsTable.columnUpdatedAt] as String,
      ),
    );
  }

  /// Serializes instance attributes matching the SQLite database column constraints.
  Map<String, dynamic> toDatabase() {
    return {
      InspectionsTable.columnClientId: clientId,
      InspectionsTable.columnUserId: userId,
      InspectionsTable.columnServerId: serverId,
      InspectionsTable.columnWorkOrderId: workOrderId,
      InspectionsTable.columnObservation: observation,
      InspectionsTable.columnCondition: condition,
      InspectionsTable.columnLatitude: latitude,
      InspectionsTable.columnLongitude: longitude,
      InspectionsTable.columnPhotoPath: photoPath,
      InspectionsTable.columnStatus: status,
      InspectionsTable.columnFailureReason: failureReason,
      InspectionsTable.columnCapturedAt: capturedAt?.toIso8601String(),
      InspectionsTable.columnSyncedAt: syncedAt?.toIso8601String(),
      InspectionsTable.columnCreatedAt: createdAt.toIso8601String(),
      InspectionsTable.columnUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  factory InspectionModel.fromEntity(InspectionEntity entity) {
    return InspectionModel(
      clientId: entity.clientId,
      userId: entity.userId,
      workOrderId: entity.workOrderId,
      serverId: entity.serverId,
      observation: entity.observation,
      condition: entity.condition,
      latitude: entity.latitude,
      longitude: entity.longitude,
      photoPath: entity.photoPath,
      status: entity.status.name,
      failureReason: entity.failureReason,
      capturedAt: entity.capturedAt,
      syncedAt: entity.syncedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  InspectionEntity toEntity() {
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
      status: InspectionStatus.fromString(status),
      failureReason: failureReason,
      capturedAt: capturedAt,
      syncedAt: syncedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
