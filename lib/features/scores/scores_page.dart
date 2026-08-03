import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/core/utils/navigation.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/models/player_profile.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

final highScoresProvider = FutureProvider<List<HighScoreRecord>>((ref) async {
  return ref.watch(profileRepositoryProvider).allHighScores();
});

class ScoresPage extends ConsumerWidget {
  const ScoresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final scoresAsync = ref.watch(highScoresProvider);
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.highScores),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => popOrGoHome(context),
        ),
      ),
      body: AtmosphereBackground(
        child: !profile.hasProfile
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.createProfileForScores,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => context.push(AppRoutes.profile),
                        child: Text(l10n.createProfile),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.levels),
                        child: Text(l10n.playAnyway),
                      ),
                    ],
                  ),
                ),
              )
            : scoresAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(l10n.errorWithDetails('$error')),
                ),
                data: (scores) {
                  final progress = profile.progress;
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                    children: [
                      SurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.overallBest,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${progress?.bestOverallScore ?? 0}',
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              l10n.highestLevelCombo(
                                progress?.highestLevelUnlocked ?? 1,
                                progress?.bestCombo ?? 0,
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.perLevel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (scores.isEmpty)
                        SurfaceCard(
                          child: Text(
                            l10n.noScoresYet,
                            style: theme.textTheme.bodyMedium,
                          ),
                        )
                      else
                        ...scores.map(
                          (highScore) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: SurfaceCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    l10n.levelNumber(highScore.level),
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${highScore.score}',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
