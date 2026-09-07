import 'package:orbytis_challenge/features/work_orders/domain/entities/work_order_entity.dart';

abstract interface class WorkOrdersRepository {
  Future<List<WorkOrderEntity>> getWorkOrders({String? status});
}
