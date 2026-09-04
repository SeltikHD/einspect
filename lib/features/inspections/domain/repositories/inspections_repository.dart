import '../entities/inspection_entity.dart';

abstract interface class InspectionsRepository {
  /// Persists partial technician input without submitting it to the sync pipeline.
  Future<void> saveDraft(InspectionEntity inspection);

  /// Validates inspection completeness, transitions lifecycle to pending, and triggers dispatch.
  Future<void> submitInspection(InspectionEntity inspection);

  /// Iterates through pending or failed queue items and pushes them to the server.
  Future<void> syncPendingQueue();

  /// Resets a failed inspection back to pending and re-executes the synchronization routine.
  Future<void> retryInspection(String clientId);

  /// Retrieves local inspections, optionally filtered by synchronization status.
  Future<List<InspectionEntity>> getInspections({
    InspectionStatus? statusFilter,
  });

  /// Finds an active or completed local inspection linked to a specific work order.
  Future<InspectionEntity?> getInspectionByWorkOrderId(String workOrderId);
}
