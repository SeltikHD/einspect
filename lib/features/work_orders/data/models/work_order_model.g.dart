// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkOrderModel _$WorkOrderModelFromJson(Map<String, dynamic> json) =>
    _WorkOrderModel(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      address: json['address'] as String,
      priority: json['priority'] as String? ?? 'medium',
      status: json['status'] as String? ?? 'open',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$WorkOrderModelToJson(_WorkOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'title': instance.title,
      'description': instance.description,
      'address': instance.address,
      'priority': instance.priority,
      'status': instance.status,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
