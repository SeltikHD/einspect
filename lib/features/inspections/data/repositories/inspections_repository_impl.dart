import '../../domain/entities/inspection_entity.dart';
import '../../domain/repositories/inspections_repository.dart';
import '../datasources/inspections_local_data_source.dart';
import '../datasources/inspections_remote_data_source.dart';
import '../models/inspection_model.dart';

final class InspectionsRepositoryImpl implements InspectionsRepository {
  final InspectionsLocalDataSource _localDataSource;
  final InspectionsRemoteDataSource _remoteDataSource;

  const InspectionsRepositoryImpl({
    required InspectionsLocalDataSource localDataSource,
    required InspectionsRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<void> saveDraft(InspectionEntity inspection) async {
    final now = DateTime.now();
    // Drafts always preserve incomplete work without triggering remote network requests
    final draft = inspection.copyWith(
      status: InspectionStatus.draft,
      failureReason: null,
      updatedAt: now,
    );

    await _localDataSource.insertOrUpdate(InspectionModel.fromEntity(draft));
  }

  @override
  Future<void> submitInspection(InspectionEntity inspection) async {
    if (!inspection.isValidForSubmission) {
      throw ArgumentError(
        'A inspeção deve conter observação válida (mínimo 10 caracteres), evidência fotográfica e GPS.',
      );
    }

    final now = DateTime.now();
    // Transition to pending state locally before attempting network dispatch
    final pendingInspection = inspection.copyWith(
      status: InspectionStatus.pending,
      failureReason: null,
      capturedAt: inspection.capturedAt ?? now,
      updatedAt: now,
    );

    await _localDataSource.insertOrUpdate(
      InspectionModel.fromEntity(pendingInspection),
    );

    // Opportunistically attempt immediate transmission if connectivity is present
    await syncPendingQueue();
  }

  @override
  Future<void> retryInspection(String clientId) async {
    final existing = await _localDataSource.findByClientId(clientId);
    if (existing == null) return;

    final queued = existing.copyWith(
      status: 'pending',
      failureReason: null,
      updatedAt: DateTime.now(),
    );

    await _localDataSource.insertOrUpdate(queued);
    await syncPendingQueue();
  }

  @override
  Future<void> syncPendingQueue() async {
    final queue = await _localDataSource.findSyncQueue();
    if (queue.isEmpty) return;

    for (final item in queue) {
      try {
        // Submitting with pre-existing clientId ensures server-side idempotency across retries
        final response = await _remoteDataSource.uploadInspection(item);

        final serverId = response['id'] as String?;
        final syncedAtString = response['syncedAt'] as String?;
        final remoteSyncedAt = syncedAtString != null
            ? DateTime.parse(syncedAtString)
            : DateTime.now();

        final syncedItem = item.copyWith(
          status: 'synced',
          serverId: serverId,
          syncedAt: remoteSyncedAt,
          failureReason: null,
          updatedAt: DateTime.now(),
        );

        await _localDataSource.insertOrUpdate(syncedItem);
      } catch (e) {
        // Isolate synchronization failure to this specific inspection; preserve local state for next cycle
        final failedItem = item.copyWith(
          status: 'failed',
          failureReason: e.toString().replaceAll('Exception: ', ''),
          updatedAt: DateTime.now(),
        );

        await _localDataSource.insertOrUpdate(failedItem);
      }
    }
  }

  @override
  Future<List<InspectionEntity>> getInspections({
    InspectionStatus? statusFilter,
  }) async {
    final models = await _localDataSource.findAll(status: statusFilter?.name);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<InspectionEntity?> getInspectionByWorkOrderId(
    String workOrderId,
  ) async {
    final model = await _localDataSource.findByWorkOrderId(workOrderId);
    return model?.toEntity();
  }
}
