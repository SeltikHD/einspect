import 'package:einspect/core/theme/app_colors.dart';
import 'package:einspect/core/widgets/app_alert_banner.dart';
import 'package:flutter/material.dart';

class GeofenceWarning extends StatelessWidget {
  final String message;

  const GeofenceWarning({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return AppAlertBanner(
      message: message,
      icon: Icons.warning_amber_rounded,
      color: colors.warning,
    );
  }
}
