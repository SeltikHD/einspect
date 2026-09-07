import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/errors/failure.dart';
import '../../../domain/entities/inspection_entity.dart';
import '../../../domain/repositories/inspections_repository.dart';
import 'inspection_form_event.dart';
import 'inspection_form_state.dart';

class InspectionFormBloc
    extends Bloc<InspectionFormEvent, InspectionFormState> {
  final InspectionsRepository _repository;

  InspectionFormBloc({required this._repository})
    : super(
        const InspectionFormState(clientId: '', userId: '', workOrderId: ''),
      ) {
    on<InspectionFormStarted>(_onStarted);
    on<InspectionObservationChanged>(_onObservationChanged);
    on<InspectionConditionChanged>(_onConditionChanged);
    on<InspectionPhotoSelected>(_onPhotoSelected);
    on<InspectionLocationRequested>(_onLocationRequested);
    on<InspectionDraftSaveSubmitted>(_onDraftSaved);
    on<InspectionCompletionSubmitted>(_onCompletionSubmitted);
    on<InspectionPhotoRemoved>(_onPhotoRemoved);
  }

  Future<void> _onStarted(
    InspectionFormStarted event,
    Emitter<InspectionFormState> emit,
  ) async {
    // Attempt restoring pre-existing draft or previous inspection record for this OS
    final existing = await _repository.getInspectionByWorkOrderId(
      workOrderId: event.workOrderId,
      userId: event.userId,
    );

    if (existing != null) {
      double? distance;
      if (existing.latitude != null && existing.longitude != null) {
        distance = Geolocator.distanceBetween(
          existing.latitude!,
          existing.longitude!,
          event.targetLatitude,
          event.targetLongitude,
        );
      }

      emit(
        InspectionFormState(
          clientId: existing.clientId,
          userId: existing.userId,
          workOrderId: existing.workOrderId,
          targetLatitude: event.targetLatitude,
          targetLongitude: event.targetLongitude,
          geofenceDistanceMeters: distance,
          observation: existing.observation ?? '',
          condition: existing.condition,
          photoPath: existing.photoPath,
          latitude: existing.latitude,
          longitude: existing.longitude,
          status: existing.status,
          isReadOnly: existing.isReadOnly,
        ),
      );
    } else {
      // Provision a fresh UUID client-side to enforce API idempotency
      emit(
        InspectionFormState(
          clientId: const Uuid().v4(),
          userId: event.userId,
          workOrderId: event.workOrderId,
          targetLatitude: event.targetLatitude,
          targetLongitude: event.targetLongitude,
        ),
      );
    }
  }

  void _onObservationChanged(
    InspectionObservationChanged event,
    Emitter<InspectionFormState> emit,
  ) {
    if (state.isReadOnly) return;
    emit(state.copyWith(observation: event.observation));
  }

  void _onConditionChanged(
    InspectionConditionChanged event,
    Emitter<InspectionFormState> emit,
  ) {
    if (state.isReadOnly) return;
    emit(state.copyWith(condition: event.condition));
  }

  Future<void> _onPhotoSelected(
    InspectionPhotoSelected event,
    Emitter<InspectionFormState> emit,
  ) async {
    if (state.isReadOnly) return;

    try {
      final permanentPath = await _repository.persistPhoto(
        tempPath: event.photoPath,
        clientId: state.clientId,
      );

      final previousPath = state.photoPath;
      if (previousPath != null && previousPath.isNotEmpty) {
        await _repository.deletePhoto(previousPath);
      }

      emit(state.copyWith(photoPath: permanentPath));
    } catch (error) {
      emit(
        state.copyWith(
          errorMessage: failureMessage(
            error,
            fallback: 'Não foi possível salvar a evidência fotográfica.',
          ),
        ),
      );
    }
  }

  Future<void> _onPhotoRemoved(
    InspectionPhotoRemoved event,
    Emitter<InspectionFormState> emit,
  ) async {
    if (state.isReadOnly) return;

    if (state.photoPath != null && state.photoPath!.isNotEmpty) {
      await _repository.deletePhoto(state.photoPath!);
    }

    emit(state.copyWith(clearPhoto: true));
  }

  Future<void> _onLocationRequested(
    InspectionLocationRequested event,
    Emitter<InspectionFormState> emit,
  ) async {
    if (state.isReadOnly) return;
    emit(state.copyWith(isFetchingLocation: true));

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          state.copyWith(
            isFetchingLocation: false,
            errorMessage: 'Os serviços de localização (GPS) estão desativados.',
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            state.copyWith(
              isFetchingLocation: false,
              errorMessage: 'Permissão de localização negada.',
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          state.copyWith(
            isFetchingLocation: false,
            errorMessage:
                'Permissão de GPS bloqueada permanentemente nas configurações.',
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      // Calculates geofence boundary distance as part of domain verification
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        state.targetLatitude,
        state.targetLongitude,
      );

      emit(
        state.copyWith(
          isFetchingLocation: false,
          latitude: position.latitude,
          longitude: position.longitude,
          geofenceDistanceMeters: distance,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isFetchingLocation: false,
          errorMessage: 'Falha ao obter coordenadas do GPS.',
        ),
      );
    }
  }

  Future<void> _onDraftSaved(
    InspectionDraftSaveSubmitted event,
    Emitter<InspectionFormState> emit,
  ) async {
    if (state.isReadOnly) return;
    emit(state.copyWith(submissionStatus: FormSubmissionStatus.submitting));

    try {
      final now = DateTime.now();
      final entity = InspectionEntity(
        clientId: state.clientId,
        userId: state.userId,
        workOrderId: state.workOrderId,
        observation: state.observation,
        condition: state.condition,
        photoPath: state.photoPath,
        latitude: state.latitude,
        longitude: state.longitude,
        status: InspectionStatus.draft,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.saveDraft(entity);

      emit(
        state.copyWith(submissionStatus: FormSubmissionStatus.successDrafted),
      );
    } catch (e) {
      emit(
        state.copyWith(
          submissionStatus: FormSubmissionStatus.failure,
          errorMessage: 'Erro ao salvar rascunho localmente.',
        ),
      );
    }
  }

  Future<void> _onCompletionSubmitted(
    InspectionCompletionSubmitted event,
    Emitter<InspectionFormState> emit,
  ) async {
    if (state.isReadOnly) return;
    if (!state.isValidForCompletion) {
      emit(
        state.copyWith(
          submissionStatus: FormSubmissionStatus.failure,
          errorMessage: 'Preencha todos os campos obrigatórios (mínimo 10 caracteres, foto e GPS).',
        ),
      );
      return;
    }

    emit(state.copyWith(submissionStatus: FormSubmissionStatus.submitting));

    try {
      final now = DateTime.now();
      final entity = InspectionEntity(
        clientId: state.clientId,
        userId: state.userId,
        workOrderId: state.workOrderId,
        observation: state.observation,
        condition: state.condition,
        photoPath: state.photoPath,
        latitude: state.latitude,
        longitude: state.longitude,
        status: InspectionStatus.draft,
        capturedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.submitInspection(entity);

      // Verify if record reached server immediately or remained pending in offline queue
      final savedRecord = await _repository.getInspectionByWorkOrderId(
        workOrderId: state.workOrderId,
        userId: state.userId,
      );

      final isSynced = savedRecord?.status == InspectionStatus.synced;

      emit(
        state.copyWith(
          submissionStatus: isSynced
              ? FormSubmissionStatus.successSynced
              : FormSubmissionStatus.successQueuedOffline,
          status: savedRecord?.status ?? InspectionStatus.pending,
          isReadOnly: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          submissionStatus: FormSubmissionStatus.failure,
          errorMessage: failureMessage(
            e,
            fallback: 'Não foi possível concluir a inspeção.',
          ),
        ),
      );
    }
  }
}
