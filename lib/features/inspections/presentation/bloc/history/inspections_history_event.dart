import '../../../domain/entities/inspection_entity.dart';

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

  const InspectionRetryRequested(this.clientId);
}

final class InspectionsManualSyncRequested extends InspectionsHistoryEvent {
  const InspectionsManualSyncRequested();
}
