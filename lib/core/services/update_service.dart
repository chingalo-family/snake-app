import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:snake_app/core/constants/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

enum UpdateMessageKind {
  upToDate,
  openPlayStore,
  openAppStore,
  unsupported,
}

class UpdateCheckResult {
  const UpdateCheckResult({
    required this.updateAvailable,
    required this.currentVersion,
    required this.messageKind,
  });

  final bool updateAvailable;
  final String currentVersion;
  final UpdateMessageKind messageKind;

  bool get shouldOpenStore =>
      messageKind == UpdateMessageKind.openPlayStore ||
      messageKind == UpdateMessageKind.openAppStore;
}

class UpdateService {
  
  bool get supportsStoreUpdates {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<UpdateCheckResult> check() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    if (!supportsStoreUpdates) {
      return UpdateCheckResult(
        updateAvailable: false,
        currentVersion: currentVersion,
        messageKind: UpdateMessageKind.unsupported,
      );
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return UpdateCheckResult(
        updateAvailable: true,
        currentVersion: currentVersion,
        messageKind: UpdateMessageKind.openPlayStore,
      );
    }

    return UpdateCheckResult(
      updateAvailable: true,
      currentVersion: currentVersion,
      messageKind: UpdateMessageKind.openAppStore,
    );
  }

  Future<void> openStoreOrUpdate() async {
    if (!supportsStoreUpdates) return;

    if (defaultTargetPlatform == TargetPlatform.android) {
      await _openPlayStore();
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _openAppStore();
    }
  }

  Future<void> _openPlayStore() async {
    final marketUri = Uri.parse(AppConstants.playStoreMarketUrl);
    if (await canLaunchUrl(marketUri)) {
      final launched = await launchUrl(
        marketUri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return;
    }
    await launchUrl(
      Uri.parse(AppConstants.playStoreUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _openAppStore() async {
    if (AppConstants.appStoreId.isNotEmpty) {
      final deepLink = Uri.parse(AppConstants.appStoreDeepLink);
      if (await canLaunchUrl(deepLink)) {
        final launched = await launchUrl(
          deepLink,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return;
      }
    }
    await launchUrl(
      Uri.parse(AppConstants.appStoreUrl),
      mode: LaunchMode.externalApplication,
    );
  }
}
