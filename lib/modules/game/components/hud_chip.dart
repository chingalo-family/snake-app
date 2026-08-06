import 'package:flutter/material.dart';
import 'package:snake_app/core/theme/app_colors.dart';

class HudChip extends StatelessWidget {
  const HudChip({
    super.key,
    required this.label,
    required this.value,
    this.accent = false,
  });

  final String label;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent
            ? AppColors.brandSecondary.withValues(alpha: 0.18)
            : AppColors.brandPrimary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label $value',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: accent ? AppColors.brandSecondary : null,
            ),
      ),
    );
  }
}
