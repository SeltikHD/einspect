import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/work_order_model.dart';
import '../../domain/repositories/work_orders_repository.dart';
import 'work_orders_event.dart';
import 'work_orders_state.dart';

class WorkOrdersBloc extends Bloc<WorkOrdersEvent, WorkOrdersState> {
  final WorkOrdersRepository _repository;
  List<WorkOrderModel> _cachedOrders = [];
  WorkOrderSort _currentSort = WorkOrderSort.urgent;
  String? _currentStatus;

  WorkOrdersBloc({required this._repository})
    : super(const WorkOrdersInitial()) {
    on<WorkOrdersFetchRequested>(_onFetchRequested);
    on<WorkOrdersFilterChanged>(_onFilterChanged);
  }

  Future<void> _onFetchRequested(
    WorkOrdersFetchRequested event,
    Emitter<WorkOrdersState> emit,
  ) async {
    if (event.completer == null && _cachedOrders.isEmpty) {
      emit(const WorkOrdersLoading());
    }

    try {
      _cachedOrders = await _repository.getWorkOrders();
      _emitFilteredOrders(emit);
    } catch (e) {
      emit(
        WorkOrdersError(message: e.toString().replaceAll('Exception: ', '')),
      );
    } finally {
      event.completer?.complete();
    }
  }

  void _onFilterChanged(
    WorkOrdersFilterChanged event,
    Emitter<WorkOrdersState> emit,
  ) {
    if (event.sort != null) _currentSort = event.sort!;
    if (event.statusFilter != null) {
      _currentStatus = event.statusFilter == 'ALL' ? null : event.statusFilter;
    }
    _emitFilteredOrders(emit);
  }

  void _emitFilteredOrders(Emitter<WorkOrdersState> emit) {
    var list = List<WorkOrderModel>.from(_cachedOrders);

    // Filter by status
    if (_currentStatus != null) {
      list = list
          .where((o) => o.status.toLowerCase() == _currentStatus!.toLowerCase())
          .toList();
    }

    // Ordenation
    switch (_currentSort) {
      case WorkOrderSort.urgent:
        list.sort(
          (a, b) =>
              _priorityWeight(b.priority)
                  .compareTo(_priorityWeight(a.priority)),
        );
        break;
      case WorkOrderSort.newest:
        list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case WorkOrderSort.scheduled:
        list.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        break;
    }

    if (list.isEmpty) {
      emit(WorkOrdersEmpty(activeStatus: _currentStatus));
    } else {
      emit(
        WorkOrdersSuccess(
          workOrders: list,
          activeSort: _currentSort,
          activeStatus: _currentStatus,
        ),
      );
    }
  }

  int _priorityWeight(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return 4;
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }
}
