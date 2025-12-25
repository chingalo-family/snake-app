import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/models/app_update_version.dart';
import 'package:snake_app/core/services/dhis2_http_service.dart';

class AppUpdateService {
  static const String datastoreNamespace = 'snake_app_update';
  static const String datastoreKey = 'app_release';

  final Dhis2HttpService? dhis2HttpService;

  AppUpdateService({this.dhis2HttpService});

  /// Check for available updates from the DHIS2 datastore
  Future<AppUpdateVersion?> checkForUpdate() async {
    if (dhis2HttpService == null) {
      return null;
    }

    try {
      final response = await dhis2HttpService!.httpGet(
        'dataStore/$datastoreNamespace/$datastoreKey',
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final updateVersion = AppUpdateVersion.fromJson(jsonData);

        // Check if remote version is newer than current version
        if (updateVersion.isNewerThan(AppInfoReference.currentAppVersion)) {
          return updateVersion;
        }
      }
    } catch (e) {
      // Silently fail if there's an error checking for updates
      // (e.g., no internet, server down, datastore not found)
      return null;
    }

    return null;
  }

  /// Download APK file from the given URL
  Future<String?> downloadApk(String apkUrl, {
    Function(int received, int total)? onProgress,
  }) async {
    try {
      final response = await http.get(Uri.parse(apkUrl));

      if (response.statusCode == 200) {
        final dir = await getExternalStorageDirectory();
        if (dir == null) return null;

        final filePath = '${dir.path}/app-update.apk';
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  /// Download APK with progress tracking using streaming
  Future<String?> downloadApkWithProgress(
    String apkUrl, {
    Function(int received, int total)? onProgress,
  }) async {
    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(apkUrl));
      final response = await client.send(request);

      if (response.statusCode == 200) {
        final dir = await getExternalStorageDirectory();
        if (dir == null) return null;

        final filePath = '${dir.path}/app-update.apk';
        final file = File(filePath);

        final contentLength = response.contentLength ?? 0;
        var received = 0;

        final sink = file.openWrite();
        await for (var chunk in response.stream) {
          received += chunk.length;
          sink.add(chunk);
          onProgress?.call(received, contentLength);
        }

        await sink.close();
        client.close();

        return filePath;
      }

      client.close();
    } catch (e) {
      return null;
    }

    return null;
  }
}
