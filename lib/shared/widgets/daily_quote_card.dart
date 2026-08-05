import 'package:flutter/material.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

/// Soft once-per-day motivation card for Home (does not block Play).
class DailyQuoteCard extends StatelessWidget {
  const DailyQuoteCard({
    super.key,
    required this.quote,
    required this.onDismiss,
  });

  final String quote;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;

    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                size: 18,
                color: isDark
                    ? AppColors.brandSecondary
                    : AppColors.brandSecondaryMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.dailyTipTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: onDismiss,
                child: Text(l10n.dailyTipGotIt),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            quote,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.35,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}
