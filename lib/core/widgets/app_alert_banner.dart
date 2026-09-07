import 'package:einspect/core/theme/app_dimensions.dart';
import 'package:einspect/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AppAlertBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;
  final Color? backgroundColor;
  final Widget? trailing;

  const AppAlertBanner({
    super.key,
    required this.message,
    required this.icon,
    required this.color,
    this.backgroundColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: .10),
        border: Border(left: BorderSide(color: color, width: 4)),
        borderRadius: BorderRadius.circular(AppDimensions.radius),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
