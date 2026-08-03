import 'package:shared_preferences/shared_preferences.dart';

/// Thin string preference layer (inspired by duka_mkononi_app).
///
/// Snake App has no passwords or secrets for MVP — use this for UI flags only.
/// If secrets are added later, wrap them in a dedicated secure-storage service
/// instead of putting them here or in Drift plaintext columns.
class PreferenceService {
  PreferenceService(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  Future<void> setString(String preferenceKey, String value) async {
    await _sharedPreferences.setString(preferenceKey, value);
  }

  String? getString(String preferenceKey) {
    return _sharedPreferences.getString(preferenceKey);
  }

  Future<void> setBool(String preferenceKey, bool value) async {
    await _sharedPreferences.setBool(preferenceKey, value);
  }

  bool? getBool(String preferenceKey) {
    return _sharedPreferences.getBool(preferenceKey);
  }
}
