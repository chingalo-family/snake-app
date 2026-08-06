import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';
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
    // Pick once per Home mount cycle for this process; quote stays stable
    // while navigating away and back until the app is restarted.
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

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider);
    final unlockedLevel = profile.highestLevelUnlocked;
    final theme = Theme.of(context);
    final l10n = context.l10n;

    ref.listen(settingsControllerProvider, (previous, next) {
      if (previous?.showDailyTip != next.showDailyTip) {
        _ensureSessionQuote();
      }
    });

    return Scaffold(
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

              if (isCompactHeight) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: isLandscape
                      ? SizedBox(
                          height: constraints.maxHeight - 24,
                          child: _HomeLandscapeBody(
                            unlockedLevel: unlockedLevel,
                            hasProfile: profile.hasProfile,
                            theme: theme,
                            l10n: l10n,
                            dailyQuoteCard: dailyQuoteSlot,
                          ),
                        )
                      : _HomeCompactPortraitBody(
                          unlockedLevel: unlockedLevel,
                          hasProfile: profile.hasProfile,
                          theme: theme,
                          l10n: l10n,
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
                    const SizedBox(height: 16),
                    _UnlockedBadge(
                      unlockedLevel: unlockedLevel,
                      theme: theme,
                      l10n: l10n,
                    ),
                    if (dailyQuoteSlot != null) ...[
                      const SizedBox(height: 14),
                      dailyQuoteSlot,
                    ],
                    const SizedBox(height: 28),
                    _HomeNavRow(
                      hasProfile: profile.hasProfile,
                      l10n: l10n,
                    ),
                    const Spacer(),
                    _PlayActionBlock(
                      hasProfile: profile.hasProfile,
                      theme: theme,
                      l10n: l10n,
                    ),
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

/// Primary Play CTA + optional no-profile hint (About lives under Settings).
class _PlayActionBlock extends StatelessWidget {
  const _PlayActionBlock({
    required this.hasProfile,
    required this.theme,
    required this.l10n,
  });

  final bool hasProfile;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryCta(
          label: l10n.play,
          icon: Icons.play_arrow_rounded,
          expanded: true,
          onPressed: () => context.push(AppRoutes.levels),
        ),
        if (!hasProfile) ...[
          const SizedBox(height: 10),
          Text(
            l10n.playFreelyHint.replaceFirst(RegExp(r'^·\s*'), ''),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ],
    );
  }
}

class _HomeCompactPortraitBody extends StatelessWidget {
  const _HomeCompactPortraitBody({
    required this.unlockedLevel,
    required this.hasProfile,
    required this.theme,
    required this.l10n,
    this.dailyQuoteCard,
  });

  final int unlockedLevel;
  final bool hasProfile;
  final ThemeData theme;
  final AppLocalizations l10n;
  final Widget? dailyQuoteCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandMark(compact: true),
        const SizedBox(height: 12),
        _UnlockedBadge(
          unlockedLevel: unlockedLevel,
          theme: theme,
          l10n: l10n,
        ),
        if (dailyQuoteCard != null) ...[
          const SizedBox(height: 12),
          dailyQuoteCard!,
        ],
        const SizedBox(height: 16),
        _HomeNavRow(hasProfile: hasProfile, l10n: l10n),
        const SizedBox(height: 20),
        _PlayActionBlock(
          hasProfile: hasProfile,
          theme: theme,
          l10n: l10n,
        ),
      ],
    );
  }
}

class _HomeLandscapeBody extends StatelessWidget {
  const _HomeLandscapeBody({
    required this.unlockedLevel,
    required this.hasProfile,
    required this.theme,
    required this.l10n,
    this.dailyQuoteCard,
  });

  final int unlockedLevel;
  final bool hasProfile;
  final ThemeData theme;
  final AppLocalizations l10n;
  final Widget? dailyQuoteCard;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandMark(compact: true),
              const SizedBox(height: 12),
              _UnlockedBadge(
                unlockedLevel: unlockedLevel,
                theme: theme,
                l10n: l10n,
              ),
              if (dailyQuoteCard != null) ...[
                const SizedBox(height: 10),
                dailyQuoteCard!,
              ],
              const Spacer(),
              _PlayActionBlock(
                hasProfile: hasProfile,
                theme: theme,
                l10n: l10n,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HomeNavColumn(hasProfile: hasProfile, l10n: l10n),
            ],
          ),
        ),
      ],
    );
  }
}

class _UnlockedBadge extends StatelessWidget {
  const _UnlockedBadge({
    required this.unlockedLevel,
    required this.theme,
    required this.l10n,
  });

  final int unlockedLevel;
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final fillColor = isDark
        ? AppColors.brandPrimary.withValues(alpha: 0.22)
        : AppColors.brandPrimary.withValues(alpha: 0.12);
    final borderColor = isDark
        ? AppColors.brandPrimaryLight.withValues(alpha: 0.55)
        : AppColors.brandPrimaryDark.withValues(alpha: 0.35);
    final labelColor =
        isDark ? AppColors.darkTextPrimary : AppColors.brandPrimaryDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_open_rounded,
            size: 16,
            color: isDark
                ? AppColors.brandSecondary
                : AppColors.brandSecondaryMuted,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              l10n.levelUnlocked(unlockedLevel),
              style: theme.textTheme.labelLarge?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeNavRow extends StatelessWidget {
  const _HomeNavRow({required this.hasProfile, required this.l10n});

  final bool hasProfile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HomeNavTile(
            icon: Icons.leaderboard_outlined,
            label: l10n.scores,
            onTap: () => context.push(AppRoutes.scores),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _HomeNavTile(
            icon: Icons.person_outline_rounded,
            label: hasProfile ? l10n.profile : l10n.createProfile,
            onTap: () => context.push(AppRoutes.profile),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _HomeNavTile(
            icon: Icons.settings_outlined,
            label: l10n.settings,
            onTap: () => context.push(AppRoutes.settings),
          ),
        ),
      ],
    );
  }
}

class _HomeNavColumn extends StatelessWidget {
  const _HomeNavColumn({required this.hasProfile, required this.l10n});

  final bool hasProfile;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HomeNavListTile(
          icon: Icons.leaderboard_outlined,
          label: l10n.scores,
          onTap: () => context.push(AppRoutes.scores),
        ),
        const SizedBox(height: 10),
        _HomeNavListTile(
          icon: Icons.person_outline_rounded,
          label: hasProfile ? l10n.profile : l10n.createProfile,
          onTap: () => context.push(AppRoutes.profile),
        ),
        const SizedBox(height: 10),
        _HomeNavListTile(
          icon: Icons.settings_outlined,
          label: l10n.settings,
          onTap: () => context.push(AppRoutes.settings),
        ),
      ],
    );
  }
}

class _HomeNavTile extends StatelessWidget {
  const _HomeNavTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isDark
                  ? AppColors.brandPrimaryLight
                  : AppColors.brandPrimaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeNavListTile extends StatelessWidget {
  const _HomeNavListTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandPrimary.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDark
                  ? AppColors.brandPrimaryLight
                  : AppColors.brandPrimaryDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}
