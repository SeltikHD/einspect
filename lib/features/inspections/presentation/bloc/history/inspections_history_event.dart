import 'package:einspect/features/inspections/domain/entities/inspection_entity.dart';

sealed class InspectionsHistoryEvent {
  const InspectionsHistoryEvent();
}

final class InspectionsHistoryFetchRequested extends InspectionsHistoryEvent {
  final String userId;
  final InspectionStatus? statusFilter;

  const InspectionsHistoryFetchRequested({
    required this.userId,
    this.statusFilter,
  });
}

final class InspectionRetryRequested extends InspectionsHistoryEvent {
  final String clientId;
  final String userId;

  const InspectionRetryRequested({
    required this.clientId,
    required this.userId,
  });
}

final class InspectionsManualSyncRequested extends InspectionsHistoryEvent {
  const InspectionsManualSyncRequested();
}
