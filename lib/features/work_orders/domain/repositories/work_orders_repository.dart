import '../../data/models/work_order_model.dart';

abstract interface class WorkOrdersRepository {
  Future<List<WorkOrderModel>> getWorkOrders({String? status});
}
