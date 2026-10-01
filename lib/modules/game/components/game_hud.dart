import 'package:flutter/material.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/modules/game/components/hud_chip.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.score,
    required this.level,
    required this.combo,
    required this.onPause,
    this.challengeTitle,
    this.remainingSeconds,
    this.targetsEaten = 0,
    this.targetCount = 0,
    this.shieldCharges = 0,
    this.length,
  });

  final int score;
  final int level;
  final int combo;
  final VoidCallback onPause;
  final String? challengeTitle;
  final int? remainingSeconds;
  final int targetsEaten;
  final int targetCount;
  final int shieldCharges;
  final int? length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
      child: Row(
        children: [
          HudChip(label: context.l10n.score, value: '$score'),
          const SizedBox(width: 8),
          if (remainingSeconds != null)
            HudChip(
              label: context.l10n.timer,
              value: '$remainingSeconds',
              accent: remainingSeconds! <= 10,
            )
          else
            HudChip(
              label: challengeTitle == null
                  ? context.l10n.level
                  : context.l10n.lengthLabel,
              value: challengeTitle == null ? '$level' : '${length ?? 0}',
            ),
          if (targetCount > 0) ...[
            const SizedBox(width: 8),
            HudChip(
              label: context.l10n.targets,
              value: '$targetsEaten/$targetCount',
              accent: true,
            ),
          ],
          if (shieldCharges > 0) ...[
            const SizedBox(width: 8),
            HudChip(
              label: context.l10n.shield,
              value: '$shieldCharges',
            ),
          ],
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

class DashHoldButton extends StatelessWidget {
  const DashHoldButton({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => onChanged(true),
      onPointerUp: (_) => onChanged(false),
      onPointerCancel: (_) => onChanged(false),
      child: Material(
        color: AppColors.brandSecondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 72,
          height: 56,
          child: Center(
            child: Text(
              context.l10n.dashHold,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
