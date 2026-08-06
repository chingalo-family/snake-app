import 'package:flutter/material.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/modules/home/components/home_nav_list_tile.dart';

class HomeNavRow extends StatelessWidget {
  const HomeNavRow({
    super.key,
    required this.hasProfile,
    required this.l10n,
    required this.onOpenScores,
    required this.onOpenProfile,
    required this.onOpenSettings,
  });

  final bool hasProfile;
  final AppLocalizations l10n;
  final VoidCallback onOpenScores;
  final VoidCallback onOpenProfile;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeNavListTile(
          icon: Icons.leaderboard_outlined,
          label: l10n.scores,
          onTap: onOpenScores,
        ),
        const SizedBox(height: 10),
        HomeNavListTile(
          icon: Icons.person_outline_rounded,
          label: hasProfile ? l10n.profile : l10n.createProfile,
          onTap: onOpenProfile,
        ),
        const SizedBox(height: 10),
        HomeNavListTile(
          icon: Icons.settings_outlined,
          label: l10n.settings,
          onTap: onOpenSettings,
        ),
      ],
    );
  }
}
