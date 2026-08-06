import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/profile_avatars.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';

class HomeWelcomeBanner extends StatelessWidget {
  const HomeWelcomeBanner({
    super.key,
    required this.hasProfile,
    required this.playerName,
    required this.avatarEmoji,
    required this.onTap,
    this.compact = false,
  });

  final bool hasProfile;
  final String? playerName;
  final String? avatarEmoji;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isDark = theme.brightness == Brightness.dark;
    final resolvedEmoji =
        avatarEmoji ?? ProfileAvatarCatalog.byId(null).emoji;
    final displayName = hasProfile
        ? (playerName?.trim().isNotEmpty == true
            ? playerName!.trim()
            : l10n.guestPlayer)
        : l10n.guestPlayer;
    final greeting =
        hasProfile ? l10n.homeWelcomeBack : l10n.homeWelcomeGuest;
    final subtitle = hasProfile
        ? l10n.homeWelcomeProfileHint
        : l10n.homeWelcomeGuestHint;

    final fillColor = isDark
        ? AppColors.darkRaised.withValues(alpha: 0.88)
        : AppColors.lightRaised;
    final borderColor = isDark
        ? AppColors.brandPrimaryLight.withValues(alpha: 0.28)
        : AppColors.brandPrimary.withValues(alpha: 0.2);
    final avatarSize = compact ? 44.0 : 52.0;

    return Material(
      color: fillColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 14,
            vertical: compact ? 10 : 12,
          ),
          child: Row(
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.brandPrimary.withValues(alpha: 0.28),
                      AppColors.brandPrimaryDark.withValues(alpha: 0.18),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.brandPrimaryLight.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  resolvedEmoji,
                  style: TextStyle(fontSize: compact ? 22 : 26),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.65,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.55,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                hasProfile
                    ? Icons.chevron_right_rounded
                    : Icons.person_add_alt_1_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
