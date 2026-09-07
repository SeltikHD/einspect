import 'package:einspect/core/theme/app_colors.dart';
import 'package:einspect/core/widgets/app_status_badge.dart';
import 'package:einspect/features/inspections/domain/entities/inspection_entity.dart';
import 'package:einspect/features/work_orders/domain/entities/work_order_entity.dart';
import 'package:flutter/material.dart';

class WorkOrderCard extends StatelessWidget {
  final WorkOrderEntity workOrder;
  final InspectionStatus? localInspectionStatus;
  final VoidCallback? onTap;

  const WorkOrderCard({
    super.key,
    required this.workOrder,
    this.localInspectionStatus,
    this.onTap,
  });

  String _translatePriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return 'URGENTE';
      case 'high':
        return 'ALTA';
      case 'medium':
        return 'MÉDIA';
      case 'low':
        return 'BAIXA';
      default:
        return priority.toUpperCase();
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return AppColors.danger;
      case 'high':
        return AppColors.danger;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.neutral;
    }
  }

  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return 'ABERTA';
      case 'in_progress':
        return 'EM ANDAMENTO';
      case 'done':
      case 'completed':
        return 'CONCLUÍDA';
      default:
        return status.toUpperCase();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return AppColors.primary;
      case 'in_progress':
        return AppColors.warning;
      case 'done':
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.neutral;
    }
  }

  (String, Color)? _getInspectionBadge(InspectionStatus? status) {
    if (status == null) return null;
    switch (status) {
      case InspectionStatus.draft:
        return ('RASCUNHO LOCAL', AppColors.neutral);
      case InspectionStatus.pending:
        return ('EM FILA (PENDENTE)', AppColors.warning);
      case InspectionStatus.synced:
        return ('INSPEÇÃO SINCRONIZADA', AppColors.success);
      case InspectionStatus.failed:
        return ('FALHA NO SYNC', AppColors.danger);
    }
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year;
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/$y às $h:$min';
  }

  @override
  Widget build(BuildContext context) {
    final inspectionBadge = _getInspectionBadge(localInspectionStatus);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    workOrder.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0B1E36),
                    ),
                  ),
                  Row(
                    children: [
                      AppStatusBadge(
                        label: _translatePriority(workOrder.priority),
                        color: _getPriorityColor(workOrder.priority),
                      ),
                      const SizedBox(width: 6),
                      AppStatusBadge(
                        label: _translateStatus(workOrder.status),
                        color: _getStatusColor(workOrder.status),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                workOrder.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0B1E36),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      workOrder.address,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Programada para: ${_formatDateTime(workOrder.scheduledAt)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              if (inspectionBadge != null) ...[
                const SizedBox(height: 10),
                AppStatusBadge(
                  label: inspectionBadge.$1,
                  color: inspectionBadge.$2,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
