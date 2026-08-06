import 'package:flutter/material.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';

class HomeUnlockedBadge extends StatelessWidget {
  const HomeUnlockedBadge({
    super.key,
    required this.unlockedLevel,
    required this.theme,
    required this.l10n,
  });

  final int unlockedLevel;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final fillColor = isDark
        ? AppColors.brandPrimary.withValues(alpha: 0.22)
        : AppColors.brandPrimary.withValues(alpha: 0.12);
    final borderColor = isDark
        ? AppColors.brandPrimaryLight.withValues(alpha: 0.55)
        : AppColors.brandPrimaryDark.withValues(alpha: 0.35);
    final labelColor =
        isDark ? AppColors.darkTextPrimary : AppColors.brandPrimaryDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_open_rounded,
            size: 16,
            color: isDark
                ? AppColors.brandSecondary
                : AppColors.brandSecondaryMuted,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              l10n.levelUnlocked(unlockedLevel),
              style: theme.textTheme.labelLarge?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
