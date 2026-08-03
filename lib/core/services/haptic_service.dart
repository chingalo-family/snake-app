import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HapticService {
  HapticService();

  bool enabled = true;

  bool get _supported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  Future<void> light() async {
    if (!enabled || !_supported) return;
    await HapticFeedback.lightImpact();
  }

  Future<void> medium() async {
    if (!enabled || !_supported) return;
    await HapticFeedback.mediumImpact();
  }

  Future<void> heavy() async {
    if (!enabled || !_supported) return;
    await HapticFeedback.heavyImpact();
  }

  Future<void> success() async {
    if (!enabled || !_supported) return;
    await HapticFeedback.mediumImpact();
  }
}
