// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InspectionModel _$InspectionModelFromJson(Map<String, dynamic> json) =>
    _InspectionModel(
      clientId: json['clientId'] as String,
      userId: json['userId'] as String,
      workOrderId: json['workOrderId'] as String,
      serverId: json['serverId'] as String?,
      observation: json['observation'] as String?,
      condition: json['condition'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      photoPath: json['photoPath'] as String?,
      status: json['status'] as String? ?? 'draft',
      failureReason: json['failureReason'] as String?,
      capturedAt: json['capturedAt'] == null
          ? null
          : DateTime.parse(json['capturedAt'] as String),
      syncedAt: json['syncedAt'] == null
          ? null
          : DateTime.parse(json['syncedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InspectionModelToJson(_InspectionModel instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'userId': instance.userId,
      'workOrderId': instance.workOrderId,
      'serverId': instance.serverId,
      'observation': instance.observation,
      'condition': instance.condition,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'photoPath': instance.photoPath,
      'status': instance.status,
      'failureReason': instance.failureReason,
      'capturedAt': instance.capturedAt?.toIso8601String(),
      'syncedAt': instance.syncedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
