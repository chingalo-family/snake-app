import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_app/app/bootstrap.dart';
import 'package:snake_app/core/services/preference_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('preference store falls back when device storage does not answer', () async {
    final preferenceStore = await openPreferenceStore(
      loadSharedPreferences: () => Completer<SharedPreferences>().future,
      timeout: const Duration(milliseconds: 30),
    );

    expect(preferenceStore, isA<MemoryPreferenceStore>());
    await preferenceStore.setString('locale_code', 'sw');
    expect(preferenceStore.getString('locale_code'), 'sw');
  });

  test('preference store uses SharedPreferences when it answers', () async {
    SharedPreferences.setMockInitialValues({'locale_code': 'en'});
    final preferenceStore = await openPreferenceStore(
      timeout: const Duration(seconds: 2),
    );

    expect(preferenceStore, isA<SharedPreferencesStore>());
    expect(preferenceStore.getString('locale_code'), 'en');
  });
}
