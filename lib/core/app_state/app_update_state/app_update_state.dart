import 'package:flutter/foundation.dart';
import 'package:snake_app/core/models/app_update_version.dart';
import 'package:snake_app/core/services/app_update_service.dart';

enum AppUpdateStatus {
  idle,
  checking,
  updateAvailable,
  downloading,
  downloaded,
  error,
}

class AppUpdateState with ChangeNotifier {
  AppUpdateStatus _status = AppUpdateStatus.idle;
  AppUpdateVersion? _availableUpdate;
  String? _downloadedApkPath;
  int _downloadProgress = 0;
  int _totalDownloadSize = 0;
  String? _errorMessage;

  AppUpdateStatus get status => _status;
  AppUpdateVersion? get availableUpdate => _availableUpdate;
  String? get downloadedApkPath => _downloadedApkPath;
  int get downloadProgress => _downloadProgress;
  int get totalDownloadSize => _totalDownloadSize;
  String? get errorMessage => _errorMessage;

  double get downloadProgressPercentage {
    if (_totalDownloadSize == 0) return 0;
    return (_downloadProgress / _totalDownloadSize) * 100;
  }

  Future<void> checkForUpdate(AppUpdateService updateService) async {
    _status = AppUpdateStatus.checking;
    _errorMessage = null;
    notifyListeners();

    try {
      final update = await updateService.checkForUpdate();
      if (update != null) {
        _availableUpdate = update;
        _status = AppUpdateStatus.updateAvailable;
      } else {
        _status = AppUpdateStatus.idle;
      }
    } catch (e) {
      _status = AppUpdateStatus.error;
      _errorMessage = 'Failed to check for updates';
    }

    notifyListeners();
  }

  Future<void> downloadUpdate(AppUpdateService updateService) async {
    if (_availableUpdate == null) return;

    _status = AppUpdateStatus.downloading;
    _downloadProgress = 0;
    _totalDownloadSize = 0;
    _errorMessage = null;
    notifyListeners();

    try {
      final filePath = await updateService.downloadApkWithProgress(
        _availableUpdate!.apkUrl,
        onProgress: (received, total) {
          _downloadProgress = received;
          _totalDownloadSize = total;
          notifyListeners();
        },
      );

      if (filePath != null) {
        _downloadedApkPath = filePath;
        _status = AppUpdateStatus.downloaded;
      } else {
        _status = AppUpdateStatus.error;
        _errorMessage = 'Failed to download update';
      }
    } catch (e) {
      _status = AppUpdateStatus.error;
      _errorMessage = 'Error downloading update: $e';
    }

    notifyListeners();
  }

  void resetState() {
    _status = AppUpdateStatus.idle;
    _availableUpdate = null;
    _downloadedApkPath = null;
    _downloadProgress = 0;
    _totalDownloadSize = 0;
    _errorMessage = null;
    notifyListeners();
  }
}
