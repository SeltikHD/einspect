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
        return ('RASCUNHO', Colors.blueGrey);
      case InspectionStatus.pending:
        return ('PENDENTE', const Color(0xFFF57C00));
      case InspectionStatus.synced:
        return ('SINCRONIZADA', const Color(0xFF2E7D32));
      case InspectionStatus.failed:
        return ('FALHA', const Color(0xFFD32F2F));
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, color) = _statusDetails(inspection.status);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: color.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
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
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 16,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        inspection.failureReason!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade900,
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
