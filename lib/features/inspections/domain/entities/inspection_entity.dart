enum InspectionStatus {
  draft,
  pending,
  synced,
  failed;

  static InspectionStatus fromString(String value) {
    return InspectionStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => InspectionStatus.draft,
    );
  }
}

class InspectionEntity {
  final String clientId;
  final String workOrderId;
  final String? serverId;
  final String? observation;
  final String? condition;
  final double? latitude;
  final double? longitude;
  final String? photoPath;
  final InspectionStatus status;
  final String? failureReason;
  final DateTime? capturedAt;
  final DateTime? syncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InspectionEntity({
    required this.clientId,
    required this.workOrderId,
    this.serverId,
    this.observation,
    this.condition,
    this.latitude,
    this.longitude,
    this.photoPath,
    required this.status,
    this.failureReason,
    this.capturedAt,
    this.syncedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Validates mandatory operational constraints before queuing for remote dispatch.
  /// Minimum length requirements and mandatory media are enforced here prior to API submission.
  bool get isValidForSubmission {
    final hasValidObservation =
        observation != null && observation!.trim().length >= 10;
    final hasEvidence = photoPath != null && photoPath!.isNotEmpty;
    final hasCoordinates = latitude != null && longitude != null;

    return hasValidObservation && hasEvidence && hasCoordinates;
  }

  InspectionEntity copyWith({
    String? clientId,
    String? workOrderId,
    String? serverId,
    String? observation,
    String? condition,
    double? latitude,
    double? longitude,
    String? photoPath,
    InspectionStatus? status,
    String? failureReason,
    DateTime? capturedAt,
    DateTime? syncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InspectionEntity(
      clientId: clientId ?? this.clientId,
      workOrderId: workOrderId ?? this.workOrderId,
      serverId: serverId ?? this.serverId,
      observation: observation ?? this.observation,
      condition: condition ?? this.condition,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoPath: photoPath ?? this.photoPath,
      status: status ?? this.status,
      failureReason: failureReason ?? this.failureReason,
      capturedAt: capturedAt ?? this.capturedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
