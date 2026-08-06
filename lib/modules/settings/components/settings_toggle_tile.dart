import 'package:flutter/material.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/modules/settings/components/settings_tile_icon.dart';

class SettingsToggleTile extends StatelessWidget {
  const SettingsToggleTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dividerColor = isDark
        ? AppColors.darkGridLine
        : AppColors.lightGridLine;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              Switch(value: value, onChanged: onChanged),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: dividerColor, indent: 70),
      ],
    );
  }
}
