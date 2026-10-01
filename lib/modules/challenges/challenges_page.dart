import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/core/constants/challenges.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/models/run_spec.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

class ChallengesPage extends ConsumerWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(profileControllerProvider).profile;
    final bests = profile == null
        ? const <String, int>{}
        : ref.watch(challengeProgressProvider).bestsFor(profile.id);
    final specs = ChallengesCatalog.all(DateTime.now());
    final sections = <ChallengeSection>[];
    for (final spec in specs) {
      if (!sections.contains(spec.section)) sections.add(spec.section);
    }

    return Scaffold(
      appBar: SnakePageAppBar(
        title: Text(l10n.challenges),
        showBackButton: true,
        showHomeButton: true,
        showMoreButton: true,
      ),
      body: AtmosphereBackground(
        child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    Text(
                      l10n.challengesIntro,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    for (final section in sections) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 8),
                        child: Text(
                          ChallengesCatalog.sectionTitle(section, l10n),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      for (final spec in specs.where((item) => item.section == section))
                        _ChallengeCard(
                          spec: spec,
                          best: bests[spec.id],
                          onStart: () => context.push(AppRoutes.challenge(spec.id)),
                        ),
                    ],
                  ],
                ),
              ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.spec,
    required this.best,
    required this.onStart,
  });

  final RunSpec spec;
  final int? best;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ChallengesCatalog.title(spec, l10n),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text(ChallengesCatalog.tip(spec, l10n)),
            const SizedBox(height: 8),
            Text(
              best == null
                  ? l10n.noChallengeBest
                  : l10n.bestScoreValue(best!),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: onStart,
                child: Text(l10n.start),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
