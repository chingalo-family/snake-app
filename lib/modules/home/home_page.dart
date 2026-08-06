import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/core/constants/profile_avatars.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/modules/home/components/home_compact_portrait_body.dart';
import 'package:snake_app/modules/home/components/home_landscape_body.dart';
import 'package:snake_app/modules/home/components/home_nav_row.dart';
import 'package:snake_app/modules/home/components/home_unlocked_badge.dart';
import 'package:snake_app/modules/home/components/home_welcome_banner.dart';
import 'package:snake_app/modules/home/components/play_fab.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';
import 'package:snake_app/shared/widgets/daily_quote_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _showDailyQuote = false;
  String _dailyQuote = '';
  bool _didPickSessionQuote = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureSessionQuote();
  }

  void _ensureSessionQuote() {
    final settings = ref.read(settingsControllerProvider);
    final quoteService = ref.read(dailyQuoteServiceProvider);
    final shouldShow = quoteService.shouldShowCard(
      dailyTipEnabled: settings.showDailyTip,
    );

    final quote = shouldShow
        ? quoteService.sessionQuote(context.l10n)
        : '';
    final shouldUpdate = !_didPickSessionQuote ||
        _showDailyQuote != shouldShow ||
        (shouldShow && _dailyQuote != quote);
    if (!shouldUpdate) return;
    setState(() {
      _didPickSessionQuote = true;
      _showDailyQuote = shouldShow;
      _dailyQuote = quote;
    });
  }

  void _dismissDailyQuote() {
    ref.read(dailyQuoteServiceProvider).dismissForSession();
    setState(() => _showDailyQuote = false);
  }

  Future<void> _openWithHaptic(String routePath) async {
    await ref.read(hapticServiceProvider).light();
    if (!mounted) return;
    context.push(routePath);
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final playerProfile = profileState.profile;
    final unlockedLevel = profileState.highestLevelUnlocked;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    ref.listen(settingsControllerProvider, (previous, next) {
      if (previous?.showDailyTip != next.showDailyTip) {
        _ensureSessionQuote();
      }
    });

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: PlayFab(
        onPressed: () => _openWithHaptic(AppRoutes.levels),
      ),
      body: AtmosphereBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape =
                  constraints.maxWidth > constraints.maxHeight;
              final isCompactHeight = constraints.maxHeight < 420;

              final dailyQuoteSlot = _showDailyQuote
                  ? DailyQuoteCard(
                      quote: _dailyQuote,
                      onDismiss: _dismissDailyQuote,
                    )
                  : null;

              final welcomeBanner = HomeWelcomeBanner(
                hasProfile: profileState.hasProfile,
                playerName: playerProfile?.name,
                avatarEmoji: playerProfile?.avatarEmoji ??
                    ProfileAvatarCatalog.byId(null).emoji,
                onTap: () => _openWithHaptic(AppRoutes.profile),
                compact: isCompactHeight,
              );

              if (isCompactHeight) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: isLandscape
                      ? SizedBox(
                          height: constraints.maxHeight - 24,
                          child: HomeLandscapeBody(
                            unlockedLevel: unlockedLevel,
                            hasProfile: profileState.hasProfile,
                            theme: theme,
                            l10n: l10n,
                            welcomeBanner: welcomeBanner,
                            onOpenScores: () =>
                                _openWithHaptic(AppRoutes.scores),
                            onOpenProfile: () =>
                                _openWithHaptic(AppRoutes.profile),
                            onOpenSettings: () =>
                                _openWithHaptic(AppRoutes.settings),
                            dailyQuoteCard: dailyQuoteSlot,
                          ),
                        )
                      : HomeCompactPortraitBody(
                          unlockedLevel: unlockedLevel,
                          hasProfile: profileState.hasProfile,
                          theme: theme,
                          l10n: l10n,
                          welcomeBanner: welcomeBanner,
                          onOpenScores: () =>
                              _openWithHaptic(AppRoutes.scores),
                          onOpenProfile: () =>
                              _openWithHaptic(AppRoutes.profile),
                          onOpenSettings: () =>
                              _openWithHaptic(AppRoutes.settings),
                          dailyQuoteCard: dailyQuoteSlot,
                        ),
                );
              }

              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BrandMark(),
                    const SizedBox(height: 14),
                    welcomeBanner,
                    const SizedBox(height: 12),
                    HomeUnlockedBadge(
                      unlockedLevel: unlockedLevel,
                      theme: theme,
                      l10n: l10n,
                    ),
                    if (dailyQuoteSlot != null) ...[
                      const SizedBox(height: 14),
                      dailyQuoteSlot,
                    ],
                    const SizedBox(height: 24),
                    HomeNavRow(
                      hasProfile: profileState.hasProfile,
                      l10n: l10n,
                      onOpenScores: () => _openWithHaptic(AppRoutes.scores),
                      onOpenProfile: () => _openWithHaptic(AppRoutes.profile),
                      onOpenSettings: () => _openWithHaptic(AppRoutes.settings),
                    ),
                    const Spacer(),
                    const SizedBox(height: 74),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
