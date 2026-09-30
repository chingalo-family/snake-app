import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/core/constants/app_constants.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;
  String _versionLabel = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  Future<void> _boot() async {
    unawaited(_loadVersionLabel());
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final settings = ref.read(settingsControllerProvider);
    try {
      await ref
          .read(profileControllerProvider.notifier)
          .refresh()
          .timeout(AppConstants.startupStepTimeout);
    } catch (error, stackTrace) {
      debugPrint('Profile refresh during splash skipped: $error\n$stackTrace');
    }
    if (!mounted) return;
    if (!settings.onboardingCompleted) {
      context.go(AppRoutes.onboarding);
    } else {
      context.go(AppRoutes.home);
    }
  }

  Future<void> _loadVersionLabel() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform()
          .timeout(const Duration(seconds: 4));
      if (!mounted) return;
      setState(() => _versionLabel = 'v${packageInfo.version}');
    } catch (error, stackTrace) {
      debugPrint('Version label skipped: $error\n$stackTrace');
    }
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

    return Scaffold(
      body: AtmosphereBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideUp,
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.brandPrimary
                                    .withValues(alpha: 0.25),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.pets_rounded,
                            size: 52,
                            color: AppColors.brandPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.appName,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.tagline.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelLarge?.copyWith(
                            letterSpacing: 1.6,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    minHeight: 3,
                    color: AppColors.brandPrimary,
                    backgroundColor: AppColors.darkGridLine,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _versionLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
