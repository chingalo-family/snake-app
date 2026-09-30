import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snake_app/app/app.dart';
import 'package:snake_app/core/l10n/app_locale.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/core/theme/app_theme.dart';

/// Shows a frame immediately, then swaps in [SnakeApp] when [start] finishes.
///
/// `main` must not wait on plugins before `runApp`. On some phones the Play
/// Store launch otherwise stays on the Android splash because the first
/// Flutter frame never arrives.
class StartupGate extends StatefulWidget {
  const StartupGate({required this.start, super.key});

  final Future<ProviderContainer> Function() start;

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  ProviderContainer? _container;
  Object? _startupError;
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool fromUser = false}) async {
    final generation = ++_loadGeneration;
    if (fromUser && mounted) {
      setState(() => _startupError = null);
    }
    try {
      final container = await widget.start();
      if (!mounted || generation != _loadGeneration) {
        container.dispose();
        return;
      }
      setState(() {
        _container = container;
        _startupError = null;
      });
    } catch (error) {
      if (!mounted || generation != _loadGeneration) return;
      setState(() => _startupError = error);
    }
  }

  @override
  void dispose() {
    _container?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final container = _container;
    if (container != null) {
      return UncontrolledProviderScope(
        container: container,
        child: const SnakeApp(),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      supportedLocales: AppLocale.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _startupError == null
          ? const _StartupSplash()
          : _StartupFailure(onRetry: () => _load(fromUser: true)),
    );
  }
}

class _StartupSplash extends StatelessWidget {
  const _StartupSplash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: LinearProgressIndicator(
          minHeight: 3,
          color: AppColors.brandPrimary,
          backgroundColor: AppColors.darkGridLine,
        ),
      ),
    );
  }
}

class _StartupFailure extends StatelessWidget {
  const _StartupFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.startupCouldNotOpen,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.startupCouldNotOpenBody,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onRetry,
                child: Text(l10n.tryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
