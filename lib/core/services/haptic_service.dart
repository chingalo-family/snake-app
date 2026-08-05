import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HapticService {
  HapticService();

  bool enabled = true;

  /// True on iOS/Android device builds. Web and desktop are no-ops.
  bool get isSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  Future<void> light() async {
    if (!enabled || !isSupported) return;
    await HapticFeedback.lightImpact();
  }

  Future<void> medium() async {
    if (!enabled || !isSupported) return;
    await HapticFeedback.mediumImpact();
  }

  Future<void> heavy() async {
    if (!enabled || !isSupported) return;
    await HapticFeedback.heavyImpact();
  }

  Future<void> success() async {
    if (!enabled || !isSupported) return;
    await HapticFeedback.mediumImpact();
  }
}
