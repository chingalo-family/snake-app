import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/bootstrap/desktop_window.dart';
import 'package:snake_app/core/constants/collectibles.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';
import 'package:snake_app/shared/widgets/page_indicator.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _pageIndex = 0;
  static const _pageCount = 4;

  bool get _isTouchPrimary {
    if (kIsWeb) return true;
    return !isDesktopPlatform;
  }

  Future<void> _finish() async {
    await ref.read(settingsControllerProvider.notifier).completeOnboarding();
    if (mounted) context.go(AppRoutes.home);
  }

  void _next() {
    if (_pageIndex >= _pageCount - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
    );
  }

  void _back() {
    if (_pageIndex <= 0) return;
    _controller.previousPage(
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isLast = _pageIndex == _pageCount - 1;

    return Scaffold(
      body: AtmosphereBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            l10n.pageOf(_pageIndex + 1, _pageCount),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _finish,
                          child: Text(l10n.skip),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      onPageChanged: (pageIndex) =>
                          setState(() => _pageIndex = pageIndex),
                      children: [
                        _OnboardSlide(
                          title: l10n.onboardingWelcomeTitle,
                          body: l10n.onboardingWelcomeBody,
                          hero: Icon(
                            Icons.pets_rounded,
                            size: 72,
                            color: AppColors.brandPrimaryLight
                                .withValues(alpha: 0.95),
                          ),
                          hints: [
                            FeatureHintCard(
                              icon: Icons.sports_esports_outlined,
                              title: l10n.tagline,
                            ),
                          ],
                        ),
                        _OnboardSlide(
                          title: l10n.onboardingMoveTitle,
                          body: _isTouchPrimary
                              ? l10n.onboardingMoveTouch
                              : l10n.onboardingMoveDesktop,
                          hero: Icon(
                            _isTouchPrimary
                                ? Icons.swipe_rounded
                                : Icons.keyboard_alt_outlined,
                            size: 72,
                            color: AppColors.brandSecondary,
                          ),
                          hints: [
                            FeatureHintCard(
                              icon: _isTouchPrimary
                                  ? Icons.touch_app_outlined
                                  : Icons.keyboard_outlined,
                              title: _isTouchPrimary
                                  ? l10n.hintSwipe
                                  : l10n.hintKeyboard,
                            ),
                          ],
                        ),
                        _OnboardSlide(
                          title: l10n.onboardingCollectTitle,
                          body: l10n.onboardingCollectBody,
                          constrainHeroToCircle: false,
                          hero: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: CollectiblesCatalog.all
                                .take(6)
                                .map(
                                  (collectible) => Chip(
                                    label: Text(
                                      '${collectible.icon} ${collectible.score}',
                                    ),
                                    backgroundColor: AppColors.brandPrimary
                                        .withValues(alpha: 0.15),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        _OnboardSlide(
                          title: l10n.onboardingProfileTitle,
                          body: l10n.onboardingProfileBody,
                          hero: const Icon(
                            Icons.emoji_events_outlined,
                            size: 72,
                            color: AppColors.brandSecondary,
                          ),
                          hints: [
                            FeatureHintCard(
                              icon: Icons.person_outline_rounded,
                              title: l10n.createProfile,
                            ),
                            FeatureHintCard(
                              icon: Icons.cloud_off_outlined,
                              title: l10n.playFreelyHint.replaceFirst('· ', ''),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PageIndicator(
                    currentPage: _pageIndex,
                    pageCount: _pageCount,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    child: Row(
                      children: [
                        if (_pageIndex > 0) ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _back,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(l10n.back),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          flex: _pageIndex > 0 ? 1 : 1,
                          child: FilledButton(
                            onPressed: _next,
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(isLast ? l10n.getStarted : l10n.next),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardSlide extends StatelessWidget {
  const _OnboardSlide({
    required this.title,
    required this.body,
    required this.hero,
    this.hints = const [],
    this.constrainHeroToCircle = true,
  });

  final String title;
  final String body;
  final Widget hero;
  final List<Widget> hints;

  /// When true, hero sits in the soft 148 circle used for icons.
  /// Multi-item visuals (collectible chips) must opt out so they size
  /// naturally instead of overflowing the circle and painting over copy.
  final bool constrainHeroToCircle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 12),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 26,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (constrainHeroToCircle)
            Container(
              width: 148,
              height: 148,
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brandPrimary.withValues(alpha: 0.12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandPrimary.withValues(alpha: 0.18),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: hero,
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.brandPrimary.withValues(alpha: 0.12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandPrimary.withValues(alpha: 0.14),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: hero,
            ),
          if (body.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              body,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.45,
                fontSize: 15,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (hints.isNotEmpty) ...[
            const SizedBox(height: 24),
            ...hints.map(
              (hintCard) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: hintCard,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
