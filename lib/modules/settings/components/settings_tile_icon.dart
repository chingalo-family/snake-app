import 'package:flutter/material.dart';
import 'package:snake_app/core/theme/app_colors.dart';

class SettingsTileIcon extends StatelessWidget {
  const SettingsTileIcon({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.brandPrimary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.brandPrimaryLight, size: 20),
    );
  }
}
