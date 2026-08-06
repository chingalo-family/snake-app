import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:window_manager/window_manager.dart';

bool get isDesktopPlatform {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows;
}

Future<void> configureDesktopWindow() async {
  if (!isDesktopPlatform) return;

  await windowManager.ensureInitialized();

  final display = await screenRetriever.getPrimaryDisplay();
  final screenSize = display.visibleSize ?? display.size;
  final screenPosition = display.visiblePosition ?? Offset.zero;

  final windowOptions = WindowOptions(
    title: 'Snake App',
    size: screenSize,
    backgroundColor: AppColors.darkBg,
    skipTaskbar: false,
    fullScreen: false,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setFullScreen(false);
    await windowManager.setSize(screenSize);
    await windowManager.setPosition(screenPosition);
    await syncDesktopWindowTheme(Brightness.dark);
    await windowManager.show();
    await windowManager.focus();
  });
}

Future<void> syncDesktopWindowTheme(Brightness brightness) async {
  if (!isDesktopPlatform) return;
  try {
    await windowManager.setBrightness(brightness);
    await windowManager.setBackgroundColor(
      brightness == Brightness.dark ? AppColors.darkBg : AppColors.lightBg,
    );
  } catch (_) {}
}

Brightness resolveThemeBrightness({
  required ThemeMode themeMode,
  required Brightness platformBrightness,
}) {
  return switch (themeMode) {
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
    ThemeMode.system => platformBrightness,
  };
}
