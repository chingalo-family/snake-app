import 'package:flutter/material.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/modules/home/components/home_nav_row.dart';
import 'package:snake_app/modules/home/components/home_unlocked_badge.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

class HomeCompactPortraitBody extends StatelessWidget {
  const HomeCompactPortraitBody({
    super.key,
    required this.unlockedLevel,
    required this.hasProfile,
    required this.theme,
    required this.l10n,
    required this.welcomeBanner,
    required this.onOpenScores,
    required this.onOpenProfile,
    required this.onOpenSettings,
    this.dailyQuoteCard,
  });

  final int unlockedLevel;
  final bool hasProfile;
  final ThemeData theme;
  final AppLocalizations l10n;
  final Widget welcomeBanner;
  final VoidCallback onOpenScores;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenSettings;
  final Widget? dailyQuoteCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandMark(compact: true),
        const SizedBox(height: 10),
        welcomeBanner,
        const SizedBox(height: 10),
        HomeUnlockedBadge(
          unlockedLevel: unlockedLevel,
          theme: theme,
          l10n: l10n,
        ),
        if (dailyQuoteCard != null) ...[
          const SizedBox(height: 10),
          dailyQuoteCard!,
        ],
        const SizedBox(height: 14),
        HomeNavRow(
          hasProfile: hasProfile,
          l10n: l10n,
          onOpenScores: onOpenScores,
          onOpenProfile: onOpenProfile,
          onOpenSettings: onOpenSettings,
        ),
        const SizedBox(height: 74),
      ],
    );
  }
}
