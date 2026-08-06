import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/preference_keys.dart';
import 'package:snake_app/core/l10n/app_locale.dart';
import 'package:snake_app/core/services/preference_service.dart';
import 'package:snake_app/core/theme/snake_skins.dart';

class AppSettings {
  const AppSettings({
    required this.sfxEnabled,
    required this.bgmEnabled,
    required this.hapticsEnabled,
    required this.showControlHints,
    required this.themeMode,
    required this.localeCode,
    required this.onboardingCompleted,
    required this.snakeSkinId,
    required this.showDailyTip,
  });

  final bool sfxEnabled;
  final bool bgmEnabled;
  final bool hapticsEnabled;
  final bool showControlHints;
  final ThemeMode themeMode;
  final String localeCode;
  final bool onboardingCompleted;
  final String snakeSkinId;
  final bool showDailyTip;

  Locale get locale => AppLocale.fromCode(localeCode);

  SnakeSkin get snakeSkin => SnakeSkinsCatalog.byId(snakeSkinId);

  AppSettings copyWith({
    bool? sfxEnabled,
    bool? bgmEnabled,
    bool? hapticsEnabled,
    bool? showControlHints,
    ThemeMode? themeMode,
    String? localeCode,
    bool? onboardingCompleted,
    String? snakeSkinId,
    bool? showDailyTip,
  }) {
    return AppSettings(
      sfxEnabled: sfxEnabled ?? this.sfxEnabled,
      bgmEnabled: bgmEnabled ?? this.bgmEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      showControlHints: showControlHints ?? this.showControlHints,
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode ?? this.localeCode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      snakeSkinId: snakeSkinId ?? this.snakeSkinId,
      showDailyTip: showDailyTip ?? this.showDailyTip,
    );
  }

  static const defaults = AppSettings(
    sfxEnabled: true,
    bgmEnabled: false,
    hapticsEnabled: true,
    showControlHints: true,
    themeMode: ThemeMode.dark,
    localeCode: AppLocale.englishCode,
    onboardingCompleted: false,
    snakeSkinId: 'forest',
    showDailyTip: true,
  );
}

class SettingsService {
  SettingsService(this._preferenceService);

  final PreferenceService _preferenceService;

  AppSettings load() {
    final localeRaw = _preferenceService.getString(PreferenceKeys.localeCode) ??
        AppLocale.englishCode;
    final snakeSkinId =
        _preferenceService.getString(PreferenceKeys.snakeSkinId) ??
            SnakeSkinsCatalog.forest.id;
    return AppSettings(
      sfxEnabled:
          _preferenceService.getBool(PreferenceKeys.sfxEnabled) ?? true,
      bgmEnabled:
          _preferenceService.getBool(PreferenceKeys.bgmEnabled) ?? false,
      hapticsEnabled:
          _preferenceService.getBool(PreferenceKeys.hapticsEnabled) ?? true,
      showControlHints:
          _preferenceService.getBool(PreferenceKeys.showControlHints) ?? true,
      themeMode: ThemeMode.dark,
      localeCode: AppLocale.normalizeCode(localeRaw),
      onboardingCompleted: _preferenceService
              .getBool(PreferenceKeys.onboardingCompleted) ??
          false,
      snakeSkinId: SnakeSkinsCatalog.byId(snakeSkinId).id,
      showDailyTip:
          _preferenceService.getBool(PreferenceKeys.showDailyTip) ?? true,
    );
  }

  Future<void> save(AppSettings settings) async {
    await _preferenceService.setBool(
      PreferenceKeys.sfxEnabled,
      settings.sfxEnabled,
    );
    await _preferenceService.setBool(
      PreferenceKeys.bgmEnabled,
      settings.bgmEnabled,
    );
    await _preferenceService.setBool(
      PreferenceKeys.hapticsEnabled,
      settings.hapticsEnabled,
    );
    await _preferenceService.setBool(
      PreferenceKeys.showControlHints,
      settings.showControlHints,
    );
    await _preferenceService.setString(
      PreferenceKeys.themeMode,
      'dark',
    );
    await _preferenceService.setString(
      PreferenceKeys.localeCode,
      settings.localeCode,
    );
    await _preferenceService.setBool(
      PreferenceKeys.onboardingCompleted,
      settings.onboardingCompleted,
    );
    await _preferenceService.setString(
      PreferenceKeys.snakeSkinId,
      settings.snakeSkinId,
    );
    await _preferenceService.setBool(
      PreferenceKeys.showDailyTip,
      settings.showDailyTip,
    );
  }
}
