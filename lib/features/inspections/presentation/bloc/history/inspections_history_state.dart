import 'package:orbytis_challenge/features/inspections/domain/entities/inspection_entity.dart';

sealed class InspectionsHistoryState {
  const InspectionsHistoryState();
}

final class InspectionsHistoryInitial extends InspectionsHistoryState {
  const InspectionsHistoryInitial();
}

final class InspectionsHistoryLoading extends InspectionsHistoryState {
  const InspectionsHistoryLoading();
}

final class InspectionsHistorySuccess extends InspectionsHistoryState {
  final List<InspectionEntity> inspections;
  final InspectionStatus? activeFilter;
  final bool isSyncing;

  const InspectionsHistorySuccess({
    required this.inspections,
    this.activeFilter,
    this.isSyncing = false,
  });

  InspectionsHistorySuccess copyWith({
    List<InspectionEntity>? inspections,
    InspectionStatus? activeFilter,
    bool? isSyncing,
  }) {
    return InspectionsHistorySuccess(
      inspections: inspections ?? this.inspections,
      activeFilter: activeFilter ?? this.activeFilter,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

final class InspectionsHistoryError extends InspectionsHistoryState {
  final String message;

  const InspectionsHistoryError(this.message);
}
