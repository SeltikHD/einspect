import 'dart:async';

import 'package:orbytis_challenge/core/errors/failure.dart';
import 'package:orbytis_challenge/core/network/network_info.dart';
import 'package:orbytis_challenge/features/inspections/data/datasources/inspections_local_data_source.dart';
import 'package:orbytis_challenge/features/inspections/data/datasources/inspections_remote_data_source.dart';
import 'package:orbytis_challenge/features/inspections/data/models/inspection_model.dart';
import 'package:orbytis_challenge/features/inspections/domain/entities/inspection_entity.dart';
import 'package:orbytis_challenge/features/inspections/domain/repositories/inspections_repository.dart';

final class InspectionsRepositoryImpl implements InspectionsRepository {
  final InspectionsLocalDataSource _localDataSource;
  final InspectionsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  final _syncStatusController = StreamController<SyncBatchStatus>.broadcast();
  StreamSubscription<bool>? _connectivitySubscription;

  InspectionsRepositoryImpl({
    required this._localDataSource,
    required this._remoteDataSource,
    required this._networkInfo,
  });

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
    final existing = await _localDataSource.findByClientId(
      clientId: inspection.clientId,
      userId: inspection.userId,
    );
    if (existing != null && existing.toEntity().isReadOnly) {
      throw StateError('Esta inspeção já foi finalizada.');
    }

    if (!inspection.isValidForSubmission) {
      throw const ValidationFailure(
        'A inspeção deve conter observação válida (mínimo 10 caracteres), evidência fotográfica e GPS.',
      );
    }

    final now = DateTime.now();
    final pendingInspection = inspection.copyWith(
      status: InspectionStatus.pending,
      failureReason: null,
      capturedAt: inspection.capturedAt ?? now,
      updatedAt: now,
    );

    await _localDataSource.insertOrUpdate(
      InspectionModel.fromEntity(pendingInspection),
    );

    await syncPendingQueue(userId: inspection.userId);
  }

  @override
  Future<void> retryInspection({
    required String clientId,
    required String userId,
  }) async {
    final existing = await _localDataSource.findByClientId(
      clientId: clientId,
      userId: userId,
    );
    if (existing == null) return;

    final queued = existing.copyWith(
      status: 'pending',
      failureReason: null,
      updatedAt: DateTime.now(),
    );

    await _localDataSource.insertOrUpdate(queued);
    await syncPendingQueue(userId: existing.userId);
  }

  @override
  Future<void> syncPendingQueue({required String userId}) async {
    final queue = await _localDataSource.findSyncQueue(userId: userId);
    if (queue.isEmpty) return;

    for (final item in queue) {
      try {
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
        final failedItem = item.copyWith(
          status: 'failed',
          failureReason: failureMessage(
            e,
            fallback: 'Falha ao sincronizar a inspeção.',
          ),
          updatedAt: DateTime.now(),
        );

        await _localDataSource.insertOrUpdate(failedItem);
      }
    }
  }

  @override
  Future<List<InspectionEntity>> getInspections({
    required String userId,
    InspectionStatus? statusFilter,
  }) async {
    final models = await _localDataSource.findAll(
      userId: userId,
      status: statusFilter?.name,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<InspectionEntity?> getInspectionByWorkOrderId({
    required String workOrderId,
    required String userId,
  }) async {
    final model = await _localDataSource.findByWorkOrderId(
      workOrderId: workOrderId,
      userId: userId,
    );
    return model?.toEntity();
  }

  @override
  Stream<SyncBatchStatus> get syncStatusStream => _syncStatusController.stream;

  @override
  void startAutoSync(String userId) {
    _connectivitySubscription?.cancel();

    // Debounces redundant connection switches and synchronizes immediately on reconnect
    _connectivitySubscription = _networkInfo.onConnectivityChanged
        .distinct()
        .listen((hasConnection) {
          if (hasConnection) {
            syncPendingQueue(userId: userId);
          }
        });
  }

  @override
  void stopAutoSync() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  @override
  Future<String> persistPhoto({
    required String tempPath,
    required String clientId,
  }) {
    return _localDataSource.savePermanentPhoto(
      sourcePath: tempPath,
      clientId: clientId,
    );
  }

  @override
  Future<void> deletePhoto(String filePath) {
    return _localDataSource.deletePermanentPhoto(filePath);
  }
}
