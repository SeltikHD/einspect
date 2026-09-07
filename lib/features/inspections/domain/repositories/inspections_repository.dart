import 'package:orbytis_challenge/features/inspections/domain/entities/inspection_entity.dart';

enum SyncBatchStatus { inProgress, success, failure }

abstract interface class InspectionsRepository {
  /// Persists partial technician input without submitting it to the sync pipeline.
  Future<void> saveDraft(InspectionEntity inspection);

  /// Validates inspection completeness, transitions lifecycle to pending, and triggers dispatch.
  Future<void> submitInspection(InspectionEntity inspection);

  /// Iterates through pending or failed queue items and pushes them to the server.
  Future<void> syncPendingQueue({required String userId});

  /// Resets a failed inspection back to pending and re-executes the synchronization routine.
  Future<void> retryInspection({
    required String clientId,
    required String userId,
  });

  /// Retrieves local inspections, optionally filtered by synchronization status.
  Future<List<InspectionEntity>> getInspections({
    required String userId,
    InspectionStatus? statusFilter,
  });

  /// Finds an active or completed local inspection linked to a specific work order.
  Future<InspectionEntity?> getInspectionByWorkOrderId({
    required String workOrderId,
    required String userId,
  });

  /// Copies an image file into safe app-owned storage
  Future<String> persistPhoto({
    required String tempPath,
    required String clientId,
  });

  /// Cleans up localized image from filesystem
  Future<void> deletePhoto(String filePath);

  /// Starts monitoring network recovery to opportunistically flush queue for the active technician
  void startAutoSync(String userId);

  /// Cancels background network listener on technician logout
  void stopAutoSync();

  /// Broadcasts sync progress notifications across the application
  Stream<SyncBatchStatus> get syncStatusStream;
}
