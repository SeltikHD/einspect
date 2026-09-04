import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/work_order_entity.dart';

part 'work_order_model.freezed.dart';
part 'work_order_model.g.dart';

@freezed
abstract class WorkOrderModel with _$WorkOrderModel {
  const WorkOrderModel._();

  const factory WorkOrderModel({
    required String id,
    required String code,
    required String title,
    @Default('') String description,
    required String address,
    @Default('medium') String priority,
    @Default('open') String status,
    required double latitude,
    required double longitude,
    required DateTime scheduledAt,
    required DateTime updatedAt,
  }) = _WorkOrderModel;

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderModelFromJson(json);

  WorkOrderEntity toEntity() => WorkOrderEntity(
    id: id,
    code: code,
    title: title,
    description: description,
    address: address,
    priority: priority,
    status: status,
    latitude: latitude,
    longitude: longitude,
    scheduledAt: scheduledAt,
    updatedAt: updatedAt,
  );
}
