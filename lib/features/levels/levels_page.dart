import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/core/utils/navigation.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

class LevelsPage extends ConsumerWidget {
  const LevelsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(profileControllerProvider).highestLevelUnlocked;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.levels),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => popOrGoHome(context),
        ),
      ),
      body: AtmosphereBackground(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          itemCount: LevelsCatalog.levels.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, levelIndex) {
            final levelConfig = LevelsCatalog.levels[levelIndex];
            final isUnlocked = levelConfig.level <= unlocked;
            return SurfaceCard(
              onTap: isUnlocked
                  ? () => context.push(AppRoutes.play(levelConfig.level))
                  : null,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? AppColors.brandPrimary.withValues(alpha: 0.18)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isUnlocked
                        ? Text(
                            '${levelConfig.level}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.brandPrimaryLight,
                            ),
                          )
                        : Icon(
                            Icons.lock_outline_rounded,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.45),
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          levelConfig.title(l10n),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isUnlocked
                              ? l10n.speedDensity(
                                  levelConfig.speedLabel(l10n),
                                  levelConfig.densityLabel(l10n),
                                )
                              : l10n.levelUnlockHint(
                                  LevelsCatalog.byLevel(levelConfig.level - 1)
                                      .unlockScore,
                                  levelConfig.level - 1,
                                ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isUnlocked)
                    FilledButton(
                      onPressed: () =>
                          context.push(AppRoutes.play(levelConfig.level)),
                      child: Text(l10n.start),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
