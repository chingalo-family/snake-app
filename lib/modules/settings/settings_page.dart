import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/core/l10n/app_locale.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/services/update_service.dart';
import 'package:snake_app/modules/settings/components/settings_nav_tile.dart';
import 'package:snake_app/modules/settings/components/settings_option_sheet.dart';
import 'package:snake_app/modules/settings/components/settings_section_header.dart';
import 'package:snake_app/modules/settings/components/settings_toggle_tile.dart';
import 'package:snake_app/modules/settings/components/snake_look_sheet.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final updates = ref.read(updateServiceProvider);
    final l10n = context.l10n;
    final languageLabel = settings.localeCode == AppLocale.swahiliCode
        ? l10n.swahili
        : l10n.english;
    final themeLabel = switch (settings.themeMode) {
      ThemeMode.light => l10n.themeLight,
      ThemeMode.system => l10n.themeSystem,
      ThemeMode.dark => l10n.themeDark,
    };

    return Scaffold(
      appBar: SnakePageAppBar(
        title: Text(l10n.settings),
        showBackButton: true,
        showHomeButton: true,
        showMoreButton: true,
      ),
      body: AtmosphereBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            SettingsSectionHeader(
              title: l10n.audio,
              icon: Icons.volume_up_outlined,
            ),
            SurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SettingsToggleTile(
                    icon: Icons.graphic_eq_rounded,
                    title: l10n.soundEffects,
                    subtitle: l10n.soundEffectsSubtitle,
                    value: settings.sfxEnabled,
                    onChanged: controller.setSfx,
                  ),
                  SettingsToggleTile(
                    icon: Icons.music_note_outlined,
                    title: l10n.backgroundMusic,
                    subtitle: l10n.backgroundMusicSubtitle,
                    value: settings.bgmEnabled,
                    onChanged: controller.setBgm,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SettingsSectionHeader(
              title: l10n.feel,
              icon: Icons.vibration_rounded,
            ),
            SurfaceCard(
              padding: EdgeInsets.zero,
              child: SettingsToggleTile(
                icon: Icons.smartphone_rounded,
                title: l10n.hapticFeedback,
                subtitle: l10n.hapticFeedbackSubtitle,
                value: settings.hapticsEnabled,
                onChanged: controller.setHaptics,
                isLast: true,
              ),
            ),
            const SizedBox(height: 20),
            SettingsSectionHeader(
              title: l10n.display,
              icon: Icons.display_settings_outlined,
            ),
            SurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SettingsToggleTile(
                    icon: Icons.tips_and_updates_outlined,
                    title: l10n.showControlHints,
                    subtitle: l10n.showControlHintsSubtitle,
                    value: settings.showControlHints,
                    onChanged: controller.setControlHints,
                  ),
                  SettingsToggleTile(
                    icon: Icons.wb_sunny_outlined,
                    title: l10n.showDailyTip,
                    subtitle: l10n.showDailyTipSubtitle,
                    value: settings.showDailyTip,
                    onChanged: controller.setShowDailyTip,
                  ),
                  SettingsNavTile(
                    icon: Icons.pets_rounded,
                    title: l10n.snakeLook,
                    subtitle: settings.snakeSkin.label(l10n),
                    onTap: () => showSnakeLookSheet(
                      context: context,
                      ref: ref,
                      selectedSkinId: settings.snakeSkinId,
                    ),
                  ),
                  SettingsNavTile(
                    icon: Icons.dark_mode_outlined,
                    title: l10n.theme,
                    subtitle: themeLabel,
                    onTap: () => showSettingsOptionSheet(
                      context: context,
                      title: l10n.theme,
                      options: [
                        l10n.themeDark,
                        l10n.themeLight,
                        l10n.themeSystem,
                      ],
                      selectedOption: themeLabel,
                      onSelect: (selectedThemeLabel) {
                        final themeMode = switch (selectedThemeLabel) {
                          final selected when selected == l10n.themeLight =>
                            ThemeMode.light,
                          final selected when selected == l10n.themeSystem =>
                            ThemeMode.system,
                          _ => ThemeMode.dark,
                        };
                        controller.setThemeMode(themeMode);
                      },
                    ),
                  ),
                  SettingsNavTile(
                    icon: Icons.language_outlined,
                    title: l10n.language,
                    subtitle: l10n.appDisplayLanguage(languageLabel),
                    isLast: true,
                    onTap: () => showSettingsOptionSheet(
                      context: context,
                      title: l10n.selectLanguage,
                      options: [l10n.english, l10n.swahili],
                      selectedOption: languageLabel,
                      onSelect: (displayLabel) {
                        final localeCode = displayLabel == l10n.swahili
                            ? AppLocale.swahiliCode
                            : AppLocale.englishCode;
                        controller.setLocaleCode(localeCode);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SettingsSectionHeader(
              title: l10n.appSection,
              icon: Icons.apps_outlined,
            ),
            SurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  if (updates.supportsStoreUpdates)
                    SettingsNavTile(
                      icon: Icons.system_update_alt_rounded,
                      title: l10n.checkForUpdates,
                      subtitle: _updateSubtitle(l10n),
                      trailingIcon: Icons.open_in_new_rounded,
                      onTap: () async {
                        final result = await updates.check();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_updateCheckMessage(l10n, result)),
                          ),
                        );
                        if (result.shouldOpenStore) {
                          await updates.openStoreOrUpdate();
                        }
                      },
                    ),
                  SettingsNavTile(
                    icon: Icons.info_outline_rounded,
                    title: l10n.about,
                    subtitle: l10n.aboutSubtitle,
                    isLast: true,
                    onTap: () => context.push(AppRoutes.about),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _updateCheckMessage(
    AppLocalizations l10n,
    UpdateCheckResult result,
  ) {
    return switch (result.messageKind) {
      UpdateMessageKind.upToDate =>
        l10n.updateUpToDate(result.currentVersion),
      UpdateMessageKind.openPlayStore =>
        l10n.updateOpenPlayStore(result.currentVersion),
      UpdateMessageKind.openAppStore =>
        l10n.updateOpenAppStore(result.currentVersion),
      UpdateMessageKind.unsupported => l10n.updateUnsupported,
    };
  }

  String _updateSubtitle(AppLocalizations l10n) {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return l10n.checkForUpdatesSubtitleAndroid;
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      return l10n.checkForUpdatesSubtitleIos;
    }
    return l10n.checkForUpdatesSubtitle;
  }
}
