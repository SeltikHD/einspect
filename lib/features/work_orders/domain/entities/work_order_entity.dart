class WorkOrderEntity {
  final String id;
  final String code;
  final String title;
  final String description;
  final String address;
  final String priority;
  final String status;
  final double latitude;
  final double longitude;
  final DateTime scheduledAt;
  final DateTime updatedAt;

  const WorkOrderEntity({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.address,
    required this.priority,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.scheduledAt,
    required this.updatedAt,
  });
}
