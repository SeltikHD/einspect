import 'package:einspect/core/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.outlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);

    final button = outlined
        ? OutlinedButton(onPressed: isLoading ? null : onPressed, child: child)
        : ElevatedButton(onPressed: isLoading ? null : onPressed, child: child);

    return SizedBox(
      height: AppDimensions.minTapTarget,
      child: icon == null || isLoading
          ? button
          : (outlined
                ? OutlinedButton.icon(
                    onPressed: onPressed,
                    icon: Icon(icon),
                    label: child,
                  )
                : ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: Icon(icon),
                    label: child,
                  )),
    );
  }
}
