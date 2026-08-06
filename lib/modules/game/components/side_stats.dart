import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/game/snake_engine.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

class SideStats extends StatelessWidget {
  const SideStats({
    super.key,
    required this.engineSnapshot,
    required this.levelConfig,
  });

  final SnakeEngineSnapshot engineSnapshot;
  final LevelConfig levelConfig;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.stats, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(context.l10n.scoreLabelValue(engineSnapshot.score)),
            Text(context.l10n.levelLabelValue(engineSnapshot.level)),
            Text(context.l10n.eatenLabelValue(engineSnapshot.itemsEaten)),
            Text(context.l10n.lastLabelValue(engineSnapshot.food.icon)),
            const Spacer(),
            Text(
              '${levelConfig.speedLabel(context.l10n)}\n${levelConfig.densityLabel(context.l10n)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
