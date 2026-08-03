import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/app/router.dart';
import 'package:snake_app/core/bootstrap/desktop_window.dart';
import 'package:snake_app/core/l10n/app_locale.dart';
import 'package:snake_app/core/theme/app_theme.dart';
import 'package:snake_app/l10n/app_localizations.dart';

class SnakeApp extends ConsumerStatefulWidget {
  const SnakeApp({super.key});

  @override
  ConsumerState<SnakeApp> createState() => _SnakeAppState();
}

class _SnakeAppState extends ConsumerState<SnakeApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      syncDesktopWindowTheme(Brightness.dark);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final audio = ref.read(audioServiceProvider);
    if (state == AppLifecycleState.resumed) {
      audio.resumeBgm();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      audio.pauseBgm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      locale: settings.locale,
      supportedLocales: AppLocale.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
