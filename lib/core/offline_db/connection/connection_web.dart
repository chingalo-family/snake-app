import 'package:drift/drift.dart';

// Web uses IndexedDB via the legacy Drift web backend.
// ignore: deprecated_member_use
import 'package:drift/web.dart';

/// Web persistence for profile/scores (settings still use SharedPreferences).
LazyDatabase openOfflineDatabaseConnection() {
  return LazyDatabase(() async {
    // ignore: deprecated_member_use
    return WebDatabase('snake_app');
  });
}
