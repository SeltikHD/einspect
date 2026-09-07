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

  (String, Color) _statusDetails(
    InspectionStatus status,
    AppColorPalette colors,
  ) {
    switch (status) {
      case InspectionStatus.draft:
        return ('RASCUNHO', colors.neutral);
      case InspectionStatus.pending:
        return ('PENDENTE', colors.warning);
      case InspectionStatus.synced:
        return ('SINCRONIZADA', colors.success);
      case InspectionStatus.failed:
        return ('FALHA', colors.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final (label, color) = _statusDetails(inspection.status, colors);

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
                  color: colors.danger.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, size: 16, color: colors.danger),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        inspection.failureReason!,
                        style: TextStyle(fontSize: 12, color: colors.danger),
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
