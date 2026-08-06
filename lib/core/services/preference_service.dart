import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> setInt(String preferenceKey, int value) async {
    await _sharedPreferences.setInt(preferenceKey, value);
  }

  int? getInt(String preferenceKey) {
    return _sharedPreferences.getInt(preferenceKey);
  }
}
