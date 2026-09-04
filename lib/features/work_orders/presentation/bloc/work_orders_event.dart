import 'dart:async';

enum WorkOrderSort {
  newest, // Most recents
  urgent, // Most importants
  scheduled, // Chronological
}

sealed class WorkOrdersEvent {
  const WorkOrdersEvent();
}

final class WorkOrdersFetchRequested extends WorkOrdersEvent {
  final String userId;
  final Completer<void>? completer;

  const WorkOrdersFetchRequested({required this.userId, this.completer});
}

final class WorkOrdersFilterChanged extends WorkOrdersEvent {
  final WorkOrderSort? sort;
  final String? statusFilter; // null = All, or 'open', 'in_progress', 'done'

  const WorkOrdersFilterChanged({this.sort, this.statusFilter});
}
