import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

/// True for Linux, macOS, and Windows (not web/mobile).
bool get isDesktopPlatform {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows;
}

/// Sizes the desktop window to the current screen's usable area
/// (not exclusive fullscreen — title bar and OS chrome stay available).
Future<void> configureDesktopWindow() async {
  if (!isDesktopPlatform) return;

  await windowManager.ensureInitialized();

  final display = await screenRetriever.getPrimaryDisplay();
  final screenSize = display.visibleSize ?? display.size;
  final screenPosition = display.visiblePosition ?? Offset.zero;

  final windowOptions = WindowOptions(
    title: 'Snake App',
    size: screenSize,
    backgroundColor: const Color(0xFF0B1F1A),
    skipTaskbar: false,
    fullScreen: false,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setFullScreen(false);
    await windowManager.setSize(screenSize);
    await windowManager.setPosition(screenPosition);
    await windowManager.show();
    await windowManager.focus();
  });
}
