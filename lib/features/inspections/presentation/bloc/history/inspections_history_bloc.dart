import 'package:einspect/core/errors/failure.dart';
import 'package:einspect/features/inspections/domain/entities/inspection_entity.dart';
import 'package:einspect/features/inspections/domain/repositories/inspections_repository.dart';
import 'package:einspect/features/inspections/presentation/bloc/history/inspections_history_event.dart';
import 'package:einspect/features/inspections/presentation/bloc/history/inspections_history_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InspectionsHistoryBloc
    extends Bloc<InspectionsHistoryEvent, InspectionsHistoryState> {
  final InspectionsRepository _repository;
  String _currentUserId = '';
  InspectionStatus? _currentFilter;

  InspectionsHistoryBloc({required this._repository})
    : super(const InspectionsHistoryInitial()) {
    on<InspectionsHistoryFetchRequested>(_onFetchRequested);
    on<InspectionRetryRequested>(_onRetryRequested);
    on<InspectionsManualSyncRequested>(_onManualSyncRequested);
  }

  Future<void> _onFetchRequested(
    InspectionsHistoryFetchRequested event,
    Emitter<InspectionsHistoryState> emit,
  ) async {
    _currentUserId = event.userId;
    _currentFilter = event.statusFilter;
    emit(const InspectionsHistoryLoading());

    try {
      final list = await _repository.getInspections(
        userId: _currentUserId,
        statusFilter: _currentFilter,
      );
      emit(
        InspectionsHistorySuccess(
          inspections: list,
          activeFilter: _currentFilter,
        ),
      );
    } catch (e) {
      emit(
        InspectionsHistoryError(
          failureMessage(e, fallback: 'Não foi possível carregar o histórico.'),
        ),
      );
    }
  }

  Future<void> _onRetryRequested(
    InspectionRetryRequested event,
    Emitter<InspectionsHistoryState> emit,
  ) async {
    try {
      await _repository.retryInspection(
        clientId: event.clientId,
        userId: event.userId,
      );
      final list = await _repository.getInspections(
        userId: _currentUserId,
        statusFilter: _currentFilter,
      );
      emit(
        InspectionsHistorySuccess(
          inspections: list,
          activeFilter: _currentFilter,
        ),
      );
    } catch (e) {
      emit(
        InspectionsHistoryError(
          failureMessage(e, fallback: 'Não foi possível reenviar a inspeção.'),
        ),
      );
    }
  }

  Future<void> _onManualSyncRequested(
    InspectionsManualSyncRequested event,
    Emitter<InspectionsHistoryState> emit,
  ) async {
    if (state is InspectionsHistorySuccess) {
      emit((state as InspectionsHistorySuccess).copyWith(isSyncing: true));
    }

    try {
      await _repository.syncPendingQueue(userId: _currentUserId);
      final list = await _repository.getInspections(
        userId: _currentUserId,
        statusFilter: _currentFilter,
      );
      emit(
        InspectionsHistorySuccess(
          inspections: list,
          activeFilter: _currentFilter,
          isSyncing: false,
        ),
      );
    } catch (e) {
      emit(
        InspectionsHistoryError(
          failureMessage(e, fallback: 'Não foi possível sincronizar a fila.'),
        ),
      );
    }
  }
}
