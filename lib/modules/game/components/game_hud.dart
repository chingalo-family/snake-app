import 'package:flutter/material.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/modules/game/components/hud_chip.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.score,
    required this.level,
    required this.combo,
    required this.onPause,
  });

  final int score;
  final int level;
  final int combo;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
      child: Row(
        children: [
          HudChip(label: context.l10n.score, value: '$score'),
          const SizedBox(width: 8),
          HudChip(label: context.l10n.level, value: '$level'),
          if (combo > 1) ...[
            const SizedBox(width: 8),
            HudChip(
              label: context.l10n.combo,
              value: context.l10n.comboValue(combo),
              accent: true,
            ),
          ],
          const Spacer(),
          IconButton(
            tooltip: context.l10n.pause,
            onPressed: onPause,
            icon: const Icon(Icons.pause_rounded),
          ),
        ],
      ),
    );
  }
}
