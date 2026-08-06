import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String offlineDatabaseFileName = 'snake_app.db';

Future<String> resolveOfflineDatabasePath(String fileName) async {
  if (Platform.isAndroid) {
    final appDir = await getApplicationSupportDirectory();
    final databasesDir = p.normalize(p.join(appDir.path, '..', 'databases'));
    await Directory(databasesDir).create(recursive: true);
    return p.join(databasesDir, fileName);
  }

  if (Platform.isIOS || Platform.isMacOS) {
    final libraryDir = await getLibraryDirectory();
    final databasesDir = p.normalize(p.join(libraryDir.path, '..', 'databases'));
    await Directory(databasesDir).create(recursive: true);
    return p.join(databasesDir, fileName);
  }

  if (Platform.isLinux || Platform.isWindows) {
    final dir = await getApplicationSupportDirectory();
    return p.join(dir.path, fileName);
  }

  throw UnsupportedError(
    'Offline database is not supported on this platform.',
  );
}
