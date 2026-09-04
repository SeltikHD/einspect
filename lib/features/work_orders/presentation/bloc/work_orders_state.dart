import '../../data/models/work_order_model.dart';
import 'work_orders_event.dart';

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
  final List<WorkOrderModel> workOrders;
  final WorkOrderSort activeSort;
  final String? activeStatus;

  const WorkOrdersSuccess({
    required this.workOrders,
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
