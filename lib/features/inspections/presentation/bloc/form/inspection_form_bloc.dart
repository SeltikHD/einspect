import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

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
      emit(
        InspectionFormState(
          clientId: existing.clientId,
          userId: existing.userId,
          workOrderId: existing.workOrderId,
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

  void _onPhotoSelected(
    InspectionPhotoSelected event,
    Emitter<InspectionFormState> emit,
  ) {
    if (state.isReadOnly) return;
    emit(state.copyWith(photoPath: event.photoPath));
  }

  void _onPhotoRemoved(
    InspectionPhotoRemoved event,
    Emitter<InspectionFormState> emit,
  ) {
    if (state.isReadOnly) return;
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

      emit(
        state.copyWith(
          isFetchingLocation: false,
          latitude: position.latitude,
          longitude: position.longitude,
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

      emit(state.copyWith(submissionStatus: FormSubmissionStatus.success));
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
        status: InspectionStatus.pending,
        capturedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.submitInspection(entity);

      emit(
        state.copyWith(
          submissionStatus: FormSubmissionStatus.success,
          status: InspectionStatus.pending,
          isReadOnly: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          submissionStatus: FormSubmissionStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }
}
