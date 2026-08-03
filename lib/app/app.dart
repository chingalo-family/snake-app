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

class _SnakeAppState extends ConsumerState<SnakeApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      syncDesktopWindowTheme(Brightness.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      // Nature-arcade dark only — same on mobile, desktop, and web.
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
