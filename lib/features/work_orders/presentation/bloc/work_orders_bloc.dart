import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:orbytis_challenge/core/errors/failure.dart';
import 'package:orbytis_challenge/features/inspections/domain/entities/inspection_entity.dart';
import 'package:orbytis_challenge/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:orbytis_challenge/features/work_orders/domain/entities/work_order_entity.dart';
import 'package:orbytis_challenge/features/work_orders/domain/repositories/work_orders_repository.dart';
import 'package:orbytis_challenge/features/work_orders/presentation/bloc/work_orders_event.dart';
import 'package:orbytis_challenge/features/work_orders/presentation/bloc/work_orders_state.dart';

class WorkOrdersBloc extends Bloc<WorkOrdersEvent, WorkOrdersState> {
  final WorkOrdersRepository _repository;
  final InspectionsRepository _inspectionsRepository;
  List<WorkOrderEntity> _cachedOrders = [];
  Map<String, InspectionStatus> _inspectionStatuses = {};
  WorkOrderSort _currentSort = WorkOrderSort.urgent;
  String? _currentStatus;
  String _currentUserId = '';

  WorkOrdersBloc({
    required this._repository,
    required this._inspectionsRepository,
  }) : super(const WorkOrdersInitial()) {
    on<WorkOrdersFetchRequested>(_onFetchRequested);
    on<WorkOrdersFilterChanged>(_onFilterChanged);
  }

  Future<void> _onFetchRequested(
    WorkOrdersFetchRequested event,
    Emitter<WorkOrdersState> emit,
  ) async {
    _currentUserId = event.userId;
    if (event.completer == null && _cachedOrders.isEmpty) {
      emit(const WorkOrdersLoading());
    }

    try {
      _cachedOrders = await _repository.getWorkOrders();

      // Correlates technician's local offline inspection queue with displayed work orders
      final localInspections = await _inspectionsRepository.getInspections(
        userId: _currentUserId,
      );
      _inspectionStatuses = {
        for (final i in localInspections) i.workOrderId: i.status,
      };

      _emitFilteredOrders(emit);
    } catch (e) {
      emit(
        WorkOrdersError(
          message: failureMessage(
            e,
            fallback: 'Não foi possível carregar as ordens de serviço.',
          ),
        ),
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
    var list = List<WorkOrderEntity>.from(_cachedOrders);

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
          inspectionStatuses: _inspectionStatuses,
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
