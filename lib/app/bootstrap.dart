import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/bootstrap/desktop_window.dart';

Future<ProviderContainer> bootstrap() async {
  await configureDesktopWindow();

  final sharedPreferences = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
  );

  // Warm Drift migrations + settings / audio side effects.
  await container.read(appDatabaseProvider).customSelect('SELECT 1').get();
  container.read(settingsControllerProvider);
  container.read(profileControllerProvider);
  await container.read(audioServiceProvider).startBgm();

  return container;
}
