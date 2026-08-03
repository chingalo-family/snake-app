import 'package:flutter/material.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/features/settings/components/settings_tile_icon.dart';

/// Tappable settings row with chevron — Duka settings chrome, Snake palette.
class SettingsNavTile extends StatelessWidget {
  const SettingsNavTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailingIcon = Icons.chevron_right_rounded,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final IconData trailingIcon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor =
        isDark ? AppColors.darkGridLine : AppColors.lightGridLine;
    final mutedColor = theme.colorScheme.onSurface.withValues(alpha: 0.45);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SettingsTileIcon(icon: icon),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.65,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(trailingIcon, color: mutedColor, size: 22),
                ],
              ),
            ),
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: dividerColor, indent: 70),
      ],
    );
  }
}
