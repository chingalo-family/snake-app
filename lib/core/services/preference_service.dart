import 'package:shared_preferences/shared_preferences.dart';

/// Local key/value settings used before and after a profile exists.
abstract class PreferenceStore {
  Future<void> setString(String preferenceKey, String value);

  String? getString(String preferenceKey);

  Future<void> setBool(String preferenceKey, bool value);

  bool? getBool(String preferenceKey);

  Future<void> setInt(String preferenceKey, int value);

  int? getInt(String preferenceKey);
}

class SharedPreferencesStore implements PreferenceStore {
  SharedPreferencesStore(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<void> setString(String preferenceKey, String value) {
    return _sharedPreferences.setString(preferenceKey, value);
  }

  @override
  String? getString(String preferenceKey) {
    return _sharedPreferences.getString(preferenceKey);
  }

  @override
  Future<void> setBool(String preferenceKey, bool value) {
    return _sharedPreferences.setBool(preferenceKey, value);
  }

  @override
  bool? getBool(String preferenceKey) {
    return _sharedPreferences.getBool(preferenceKey);
  }

  @override
  Future<void> setInt(String preferenceKey, int value) {
    return _sharedPreferences.setInt(preferenceKey, value);
  }

  @override
  int? getInt(String preferenceKey) {
    return _sharedPreferences.getInt(preferenceKey);
  }
}

/// Used when device storage does not answer during launch.
///
/// Play installs on some phones leave SharedPreferences blocked behind a
/// backup or package-manager lock. The session still opens; the next launch
/// tries persistent storage again.
class MemoryPreferenceStore implements PreferenceStore {
  final Map<String, Object> _values = {};

  @override
  Future<void> setString(String preferenceKey, String value) async {
    _values[preferenceKey] = value;
  }

  @override
  String? getString(String preferenceKey) {
    final value = _values[preferenceKey];
    return value is String ? value : null;
  }

  @override
  Future<void> setBool(String preferenceKey, bool value) async {
    _values[preferenceKey] = value;
  }

  @override
  bool? getBool(String preferenceKey) {
    final value = _values[preferenceKey];
    return value is bool ? value : null;
  }

  @override
  Future<void> setInt(String preferenceKey, int value) async {
    _values[preferenceKey] = value;
  }

  @override
  int? getInt(String preferenceKey) {
    final value = _values[preferenceKey];
    return value is int ? value : null;
  }
}

class PreferenceService {
  PreferenceService(this._preferenceStore);

  final PreferenceStore _preferenceStore;

  Future<void> setString(String preferenceKey, String value) async {
    await _preferenceStore.setString(preferenceKey, value);
  }

  String? getString(String preferenceKey) {
    return _preferenceStore.getString(preferenceKey);
  }

  Future<void> setBool(String preferenceKey, bool value) async {
    await _preferenceStore.setBool(preferenceKey, value);
  }

  bool? getBool(String preferenceKey) {
    return _preferenceStore.getBool(preferenceKey);
  }

  Future<void> setInt(String preferenceKey, int value) async {
    await _preferenceStore.setInt(preferenceKey, value);
  }

  int? getInt(String preferenceKey) {
    return _preferenceStore.getInt(preferenceKey);
  }
}
