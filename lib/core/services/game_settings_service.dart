import 'package:shared_preferences/shared_preferences.dart';

class GameSettingsService {
  static const String _soundEffectsKey = 'game_sound_effects_enabled';
  static const String _hapticFeedbackKey = 'game_haptic_feedback_enabled';

  /// Get sound effects preference (defaults to true)
  static Future<bool> getSoundEffectsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundEffectsKey) ?? true;
  }

  /// Set sound effects preference
  static Future<void> setSoundEffectsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundEffectsKey, enabled);
  }

  /// Get haptic feedback preference (defaults to true)
  static Future<bool> getHapticFeedbackEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hapticFeedbackKey) ?? true;
  }

  /// Set haptic feedback preference
  static Future<void> setHapticFeedbackEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticFeedbackKey, enabled);
  }
}
