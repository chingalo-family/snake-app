import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:snake_app/core/offline_db/database_path.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

LazyDatabase openOfflineDatabaseConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final path = await resolveOfflineDatabasePath(offlineDatabaseFileName);
    return NativeDatabase.createInBackground(File(path));
  });
}
