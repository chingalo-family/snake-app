import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/bootstrap/desktop_window.dart';
import 'package:snake_app/core/constants/app_constants.dart';
import 'package:snake_app/core/services/preference_service.dart';

Future<ProviderContainer> bootstrap() async {
  await configureDesktopWindow();

  final preferenceStore = await openPreferenceStore();
  final container = ProviderContainer(
    overrides: [
      preferenceStoreProvider.overrideWithValue(preferenceStore),
    ],
  );

  container.read(settingsControllerProvider);
  container.read(profileControllerProvider);
  unawaited(_warmDatabase(container));
  unawaited(_startBackgroundMusic(container));

  return container;
}

@visibleForTesting
Future<PreferenceStore> openPreferenceStore({
  Future<SharedPreferences> Function()? loadSharedPreferences,
  Duration timeout = AppConstants.startupStepTimeout,
}) async {
  try {
    final load = loadSharedPreferences ?? SharedPreferences.getInstance;
    final sharedPreferences = await load().timeout(timeout);
    return SharedPreferencesStore(sharedPreferences);
  } catch (error, stackTrace) {
    debugPrint(
      'SharedPreferences unavailable at launch, using session memory: '
      '$error\n$stackTrace',
    );
    return MemoryPreferenceStore();
  }
}

Future<void> _warmDatabase(ProviderContainer container) async {
  try {
    await container
        .read(appDatabaseProvider)
        .customSelect('SELECT 1')
        .get()
        .timeout(AppConstants.startupStepTimeout);
  } catch (error, stackTrace) {
    debugPrint('Database warmup skipped: $error\n$stackTrace');
  }
}

Future<void> _startBackgroundMusic(ProviderContainer container) async {
  try {
    await container
        .read(audioServiceProvider)
        .startBgm()
        .timeout(AppConstants.startupStepTimeout);
  } catch (error, stackTrace) {
    debugPrint('Background music startup skipped: $error\n$stackTrace');
  }
}
