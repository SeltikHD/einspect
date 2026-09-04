import '../../domain/entities/work_order_entity.dart';
import '../../domain/repositories/work_orders_repository.dart';
import '../datasources/work_orders_remote_data_source.dart';

final class WorkOrdersRepositoryImpl implements WorkOrdersRepository {
  final WorkOrdersRemoteDataSource _remoteDataSource;

  const WorkOrdersRepositoryImpl({required this._remoteDataSource});

  @override
  Future<List<WorkOrderEntity>> getWorkOrders({String? status}) async {
    final models = await _remoteDataSource.getWorkOrders(status: status);

    return models.map((m) => m.toEntity()).toList();
  }
}
