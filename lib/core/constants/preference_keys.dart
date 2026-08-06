/// Preference keys for local settings (SharedPreferences via PreferenceService).
/// Domain data (profile / scores) lives in Drift [AppDatabase].
abstract final class PreferenceKeys {
  static const sfxEnabled = 'sfx_enabled';
  static const bgmEnabled = 'bgm_enabled';
  static const hapticsEnabled = 'haptics_enabled';
  static const showControlHints = 'show_control_hints';
  static const themeMode = 'theme_mode';
  static const localeCode = 'locale_code';
  static const onboardingCompleted = 'onboarding_completed';
  static const snakeSkinId = 'snake_skin_id';
  static const showDailyTip = 'show_daily_tip';
  static const dailyQuoteLastIndex = 'daily_quote_last_index';
}
