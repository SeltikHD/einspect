sealed class InspectionFormEvent {
  const InspectionFormEvent();
}

/// Initializes the form with existing local data or prepares a fresh UUID.
final class InspectionFormStarted extends InspectionFormEvent {
  final String workOrderId;
  final String userId;
  final double targetLatitude;
  final double targetLongitude;

  const InspectionFormStarted({
    required this.workOrderId,
    required this.userId,
    required this.targetLatitude,
    required this.targetLongitude,
  });
}

final class InspectionObservationChanged extends InspectionFormEvent {
  final String observation;

  const InspectionObservationChanged(this.observation);
}

final class InspectionConditionChanged extends InspectionFormEvent {
  final String condition;

  const InspectionConditionChanged(this.condition);
}

final class InspectionPhotoSelected extends InspectionFormEvent {
  final String photoPath;

  const InspectionPhotoSelected(this.photoPath);
}

/// Triggers device geolocation retrieval via GPS.
final class InspectionLocationRequested extends InspectionFormEvent {
  const InspectionLocationRequested();
}

/// Saves incomplete inspection data without network validation.
final class InspectionDraftSaveSubmitted extends InspectionFormEvent {
  const InspectionDraftSaveSubmitted();
}

/// Enforces completeness validation, marks state as pending, and triggers sync.
final class InspectionCompletionSubmitted extends InspectionFormEvent {
  const InspectionCompletionSubmitted();
}

final class InspectionPhotoRemoved extends InspectionFormEvent {
  const InspectionPhotoRemoved();
}
