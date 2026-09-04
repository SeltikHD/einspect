import '../../domain/repositories/work_orders_repository.dart';
import '../datasources/work_orders_remote_data_source.dart';
import '../models/work_order_model.dart';

final class WorkOrdersRepositoryImpl implements WorkOrdersRepository {
  final WorkOrdersRemoteDataSource _remoteDataSource;

  const WorkOrdersRepositoryImpl({required this._remoteDataSource});

  @override
  Future<List<WorkOrderModel>> getWorkOrders({String? status}) {
    return _remoteDataSource.getWorkOrders(status: status);
  }
}
