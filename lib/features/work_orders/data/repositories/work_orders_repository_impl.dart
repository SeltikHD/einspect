import 'package:orbytis_challenge/features/work_orders/data/datasources/work_orders_remote_data_source.dart';
import 'package:orbytis_challenge/features/work_orders/domain/entities/work_order_entity.dart';
import 'package:orbytis_challenge/features/work_orders/domain/repositories/work_orders_repository.dart';

final class WorkOrdersRepositoryImpl implements WorkOrdersRepository {
  final WorkOrdersRemoteDataSource _remoteDataSource;

  const WorkOrdersRepositoryImpl({required this._remoteDataSource});

  @override
  Future<List<WorkOrderEntity>> getWorkOrders({String? status}) async {
    final models = await _remoteDataSource.getWorkOrders(status: status);

    return models.map((m) => m.toEntity()).toList();
  }
}
