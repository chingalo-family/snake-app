import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/app_constants.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/models/game_mode.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/core/theme/snake_skins.dart';

/// Fixed 9:16 social-post canvas (Stories / Reels / feed-friendly).
/// Captured at pixelRatio 3 → ~1080×1920 PNG.
class ShareScoreCard extends StatelessWidget {
  const ShareScoreCard({
    super.key,
    required this.score,
    required this.level,
    required this.skin,
    this.mode,
    this.isOverallBest = false,
    this.isNewBest = false,
    this.unlockedLevel,
    this.unlockedSkinLabels = const [],
  });

  static const double socialWidth = 360;
  static const double socialHeight = 640;
  static const String appIconAsset = 'assets/app-icon.png';

  final int score;
  final int level;
  final GameMode? mode;
  final SnakeSkin skin;
  final bool isOverallBest;
  final bool isNewBest;
  final int? unlockedLevel;
  final List<String> unlockedSkinLabels;

  bool get hasAchievements =>
      isNewBest || unlockedLevel != null || unlockedSkinLabels.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SizedBox(
      width: socialWidth,
      height: socialHeight,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B1F1A),
              Color(0xFF12352C),
              Color(0xFF0D2820),
              Color(0xFF0B1F1A),
            ],
            stops: [0.0, 0.35, 0.75, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      appIconAsset,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 56,
                          height: 56,
                          color: AppColors.brandPrimary.withValues(alpha: 0.22),
                          child: const Icon(
                            Icons.pets_rounded,
                            color: AppColors.brandPrimaryLight,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.appName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.darkTextPrimary,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppConstants.tagline,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppConstants.familyCredit,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.darkTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
              if (isOverallBest) ...[
                Text(
                  l10n.shareCardOverallBestLabel,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.brandPrimaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                '$score',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge?.copyWith(
                  color: AppColors.brandSecondary,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  fontSize: 72,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isOverallBest
                    ? l10n.shareCardOverallBestSummary(
                        score,
                        level,
                      )
                    : l10n.scoreLevelSummary(score, level),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.darkTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isOverallBest)
                    _Chip(label: l10n.overallBest, amber: true)
                  else if (mode != null) ...[
                    _Chip(label: mode!.label(l10n)),
                    const SizedBox(width: 8),
                    _Chip(label: skin.label(l10n), amber: true),
                  ] else
                    _Chip(label: skin.label(l10n), amber: true),
                ],
              ),
              const SizedBox(height: 22),
              _MiniSnakePreview(skin: skin),
              if (hasAchievements) ...[
                const Spacer(),
                Text(
                  l10n.shareCardAchievements,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (isNewBest) _AchievementRow(text: l10n.newPersonalBest),
                if (unlockedLevel != null)
                  _AchievementRow(
                    text: l10n.levelUnlockedBanner(unlockedLevel!),
                  ),
                for (final skinLabel in unlockedSkinLabels)
                  _AchievementRow(text: l10n.skinUnlockedBanner(skinLabel)),
              ] else
                const Spacer(flex: 2),
              const Spacer(),
              Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.brandPrimaryLight.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.shareCardPromo,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkTextPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.shareCardAvailableOn,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.darkTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _StoreBadgeRow(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.shareCardDownloadBoth,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.darkTextMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreBadgeRow extends StatelessWidget {
  const _StoreBadgeRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: _StoreBadge(
            icon: Icons.shop_rounded,
            label: l10n.shareCardGooglePlay,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StoreBadge(
            icon: Icons.apple,
            label: l10n.shareCardAppStore,
          ),
        ),
      ],
    );
  }
}

class _StoreBadge extends StatelessWidget {
  const _StoreBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.darkRaised.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.brandPrimaryLight.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.brandPrimaryLight),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.amber = false});

  final String label;
  final bool amber;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (amber ? AppColors.brandSecondary : AppColors.brandPrimary)
            .withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: amber
                  ? AppColors.brandSecondary
                  : AppColors.brandPrimaryLight,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _AchievementRow extends StatelessWidget {
  const _AchievementRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: AppColors.brandPrimaryLight,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkTextSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniSnakePreview extends StatelessWidget {
  const _MiniSnakePreview({required this.skin});

  final SnakeSkin skin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var segmentIndex = 0; segmentIndex < 5; segmentIndex++)
            Container(
              width: 26,
              height: 26,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                gradient: segmentIndex == 4
                    ? LinearGradient(
                        colors: [skin.headLight, skin.headDark],
                      )
                    : null,
                color: segmentIndex == 4
                    ? null
                    : skin.body.withValues(
                        alpha: skin.hasStripe && segmentIndex.isOdd
                            ? 0.7
                            : 0.9,
                      ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
        ],
      ),
    );
  }
}
