import 'package:flutter/material.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

class HomeNavListTile extends StatelessWidget {
  const HomeNavListTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDark
                  ? AppColors.brandPrimaryLight
                  : AppColors.brandPrimaryDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}
