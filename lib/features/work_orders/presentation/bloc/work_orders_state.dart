import 'package:einspect/features/inspections/domain/entities/inspection_entity.dart';
import 'package:einspect/features/work_orders/domain/entities/work_order_entity.dart';
import 'package:einspect/features/work_orders/presentation/bloc/work_orders_event.dart';

sealed class WorkOrdersState {
  const WorkOrdersState();
}

final class WorkOrdersInitial extends WorkOrdersState {
  const WorkOrdersInitial();
}

final class WorkOrdersLoading extends WorkOrdersState {
  const WorkOrdersLoading();
}

final class WorkOrdersSuccess extends WorkOrdersState {
  final List<WorkOrderEntity> workOrders;
  final Map<String, InspectionStatus> inspectionStatuses;
  final WorkOrderSort activeSort;
  final String? activeStatus;

  const WorkOrdersSuccess({
    required this.workOrders,
    this.inspectionStatuses = const {},
    this.activeSort = WorkOrderSort.urgent,
    this.activeStatus,
  });
}

final class WorkOrdersEmpty extends WorkOrdersState {
  final String? activeStatus;

  const WorkOrdersEmpty({this.activeStatus});
}

final class WorkOrdersError extends WorkOrdersState {
  final String message;

  const WorkOrdersError({required this.message});
}
