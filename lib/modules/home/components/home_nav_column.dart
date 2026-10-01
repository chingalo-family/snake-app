import 'package:flutter/material.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/modules/home/components/home_nav_row.dart';

class HomeNavColumn extends StatelessWidget {
  const HomeNavColumn({
    super.key,
    required this.hasProfile,
    required this.l10n,
    required this.onOpenScores,
    required this.onOpenChallenges,
    required this.onOpenProfile,
    required this.onOpenSettings,
  });

  final bool hasProfile;
  final AppLocalizations l10n;
  final VoidCallback onOpenScores;
  final VoidCallback onOpenChallenges;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return HomeNavRow(
      hasProfile: hasProfile,
      l10n: l10n,
      onOpenScores: onOpenScores,
      onOpenChallenges: onOpenChallenges,
      onOpenProfile: onOpenProfile,
      onOpenSettings: onOpenSettings,
    );
  }
}
