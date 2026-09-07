import 'package:einspect/core/theme/app_colors.dart';
import 'package:einspect/core/widgets/app_card.dart';
import 'package:einspect/core/widgets/app_status_badge.dart';
import 'package:einspect/features/inspections/domain/entities/inspection_entity.dart';
import 'package:flutter/material.dart';

class InspectionHistoryCard extends StatelessWidget {
  final InspectionEntity inspection;
  final VoidCallback? onRetry;

  const InspectionHistoryCard({
    super.key,
    required this.inspection,
    this.onRetry,
  });

  (String, Color) _statusDetails(InspectionStatus status) {
    switch (status) {
      case InspectionStatus.draft:
        return ('RASCUNHO', AppColors.neutral);
      case InspectionStatus.pending:
        return ('PENDENTE', AppColors.warning);
      case InspectionStatus.synced:
        return ('SINCRONIZADA', AppColors.success);
      case InspectionStatus.failed:
        return ('FALHA', AppColors.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, color) = _statusDetails(inspection.status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'OS: ${inspection.workOrderId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                AppStatusBadge(label: label, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              inspection.observation?.isNotEmpty == true
                  ? inspection.observation!
                  : 'Rascunho sem observações preenchidas.',
              style: const TextStyle(fontSize: 14),
            ),
            if (inspection.status == InspectionStatus.failed &&
                inspection.failureReason != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 16,
                      color: AppColors.danger,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        inspection.failureReason!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                    if (onRetry != null)
                      TextButton(
                        onPressed: onRetry,
                        child: const Text('Reenviar'),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
