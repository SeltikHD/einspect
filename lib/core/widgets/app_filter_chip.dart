import 'package:einspect/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;
  final IconData? icon;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isSelected ? Colors.white : AppColors.neutral;

    return ChoiceChip(
      label: Text(label),
      avatar: icon == null
          ? null
          : Icon(icon, size: 18, color: foregroundColor),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      visualDensity: VisualDensity.standard,
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: foregroundColor,
      ),
    );
  }
}
