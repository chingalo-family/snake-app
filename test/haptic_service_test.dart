import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snake_app/core/services/haptic_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('haptics respect enabled flag without throwing', () async {
    final hapticService = HapticService();

    hapticService.enabled = false;
    await hapticService.light();
    await hapticService.medium();
    await hapticService.heavy();
    await hapticService.success();

    hapticService.enabled = true;
    await hapticService.light();
    await hapticService.medium();
    await hapticService.heavy();
    await hapticService.success();

    final isMobilePlatform = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    expect(hapticService.isSupported, isMobilePlatform);
  });
}
