import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/models/player_profile.dart';
import 'package:snake_app/core/services/share_score_service.dart';
import 'package:snake_app/core/utils/page_insets.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';
import 'package:snake_app/shared/widgets/share_score_card.dart';

final highScoresProvider = FutureProvider<List<HighScoreRecord>>((ref) async {
  return ref.watch(profileRepositoryProvider).allHighScores();
});

class ScoresPage extends ConsumerStatefulWidget {
  const ScoresPage({super.key});

  @override
  ConsumerState<ScoresPage> createState() => _ScoresPageState();
}

class _ScoresPageState extends ConsumerState<ScoresPage> {
  bool _isSharingOverall = false;

  Future<void> _shareOverallBest({
    required int bestScore,
    required int highestLevel,
  }) async {
    if (_isSharingOverall || bestScore <= 0) return;
    setState(() => _isSharingOverall = true);
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final skin = ref.read(settingsControllerProvider).snakeSkin;
    final profile = ref.read(profileControllerProvider).profile;
    try {
      final outcome =
          await ref.read(shareScoreServiceProvider).shareSocialPostImage(
                context: context,
                card: ShareScoreCard(
                  score: bestScore,
                  level: highestLevel,
                  skin: skin,
                  isOverallBest: true,
                  playerName: profile?.name,
                  playerAvatarEmoji: profile?.avatarEmoji,
                ),
                shareText: l10n.shareTextOverallCaption(
                  bestScore,
                  highestLevel,
                ),
              );
      if (!mounted) return;
      switch (outcome) {
        case ShareScoreOutcome.cancelled:
        case ShareScoreOutcome.shared:
          break;
        case ShareScoreOutcome.savedToDisk:
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.shareSavedToDisk)),
          );
        case ShareScoreOutcome.failed:
          messenger.showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
      }
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.shareFailed)));
    } finally {
      if (mounted) setState(() => _isSharingOverall = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider);
    final scoresAsync = ref.watch(highScoresProvider);
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: SnakePageAppBar(
        title: Text(l10n.highScores),
        showBackButton: true,
        showHomeButton: true,
        showMoreButton: true,
      ),
      body: AtmosphereBackground(
        child: !profile.hasProfile
            ? Center(
                child: Padding(
                  padding: pageScrollPadding(
                    context,
                    left: 28,
                    top: 28,
                    right: 28,
                    bottom: 28,
                  ),
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
                  final bestOverall = progress?.bestOverallScore ?? 0;
                  final highestLevel = progress?.highestLevelUnlocked ?? 1;
                  final canShareOverall = bestOverall > 0;

                  return ListView(
                    padding: pageScrollPadding(context),
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
                              '$bestOverall',
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              l10n.highestLevelCombo(
                                highestLevel,
                                progress?.bestCombo ?? 0,
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.65),
                              ),
                            ),
                            if (canShareOverall) ...[
                              const SizedBox(height: 14),
                              OutlinedButton.icon(
                                onPressed: _isSharingOverall
                                    ? null
                                    : () => _shareOverallBest(
                                          bestScore: bestOverall,
                                          highestLevel: highestLevel,
                                        ),
                                icon: _isSharingOverall
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.image_outlined),
                                label: Text(
                                  _isSharingOverall
                                      ? l10n.sharePreparing
                                      : l10n.shareOverallBest,
                                ),
                              ),
                            ],
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
