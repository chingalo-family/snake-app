import 'package:flutter/material.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';

class AtmosphereBackground extends StatelessWidget {
  const AtmosphereBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkAtmosphere : AppColors.lightAtmosphere,
      ),
      child: child,
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.appName,
          style: (compact
                  ? theme.textTheme.headlineMedium
                  : theme.textTheme.displaySmall)
              ?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: 8),
          Text(
            l10n.tagline,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }
}

class PrimaryCta extends StatelessWidget {
  const PrimaryCta({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size(expanded ? double.infinity : 48, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            )
          : Row(
              mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 22),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );
    if (!expanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  static const BorderRadius _borderRadius = BorderRadius.all(
    Radius.circular(20),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkRaised : AppColors.lightRaised;
    final borderColor =
        isDark ? AppColors.darkGridLine : AppColors.lightGridLine;

    final paddedChild = Padding(padding: padding, child: child);
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: _borderRadius,
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: onTap == null
            ? paddedChild
            : InkWell(
                onTap: onTap,
                borderRadius: _borderRadius,
                child: paddedChild,
              ),
      ),
    );
  }
}

/// Soft feature row used under onboarding heroes.
class FeatureHintCard extends StatelessWidget {
  const FeatureHintCard({
    super.key,
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkRaised : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkGridLine : AppColors.lightGridLine,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.brandPrimaryLight, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
