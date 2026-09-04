import '../../../domain/entities/inspection_entity.dart';

enum FormSubmissionStatus {
  idle,
  submitting,
  successDrafted,
  successSynced,
  successQueuedOffline,
  failure,
}

class InspectionFormState {
  final String clientId;
  final String workOrderId;
  final String userId;
  final String observation;
  final String? condition;
  final String? photoPath;
  final double? latitude;
  final double? longitude;
  final InspectionStatus status;
  final bool isReadOnly;
  final bool isFetchingLocation;
  final FormSubmissionStatus submissionStatus;
  final String? errorMessage;

  const InspectionFormState({
    required this.clientId,
    required this.userId,
    required this.workOrderId,
    this.observation = '',
    this.condition,
    this.photoPath,
    this.latitude,
    this.longitude,
    this.status = InspectionStatus.draft,
    this.isReadOnly = false,
    this.isFetchingLocation = false,
    this.submissionStatus = FormSubmissionStatus.idle,
    this.errorMessage,
  });

  /// Business validation rule: 10+ char observation, valid photo path, and captured coordinates.
  bool get isValidForCompletion =>
      !isReadOnly &&
      observation.trim().length >= 10 &&
      photoPath != null &&
      photoPath!.isNotEmpty &&
      latitude != null &&
      longitude != null;

  InspectionFormState copyWith({
    String? clientId,
    String? userId,
    String? workOrderId,
    String? observation,
    String? condition,
    String? photoPath,
    bool clearPhoto = false,
    double? latitude,
    double? longitude,
    InspectionStatus? status,
    bool? isReadOnly,
    bool? isFetchingLocation,
    FormSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return InspectionFormState(
      clientId: clientId ?? this.clientId,
      userId: userId ?? this.userId,
      workOrderId: workOrderId ?? this.workOrderId,
      observation: observation ?? this.observation,
      condition: condition ?? this.condition,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage,
    );
  }
}
