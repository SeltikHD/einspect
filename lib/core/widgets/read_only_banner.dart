import 'package:einspect/core/theme/app_colors.dart';
import 'package:einspect/core/widgets/app_alert_banner.dart';
import 'package:flutter/material.dart';

class ReadOnlyBanner extends StatelessWidget {
  final String message;
  final bool isSynced;

  const ReadOnlyBanner({
    super.key,
    required this.message,
    required this.isSynced,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return AppAlertBanner(
      message: message,
      icon: isSynced ? Icons.check_circle_outline : Icons.schedule,
      color: isSynced ? colors.success : colors.warning,
    );
  }
}
