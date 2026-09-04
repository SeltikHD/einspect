import '../entities/work_order_entity.dart';

abstract interface class WorkOrdersRepository {
  Future<List<WorkOrderEntity>> getWorkOrders({String? status});
}
