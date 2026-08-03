abstract final class AppConstants {
  static const String appName = 'Snake App';
  static const String packageId = 'chingalo.family.snake_app';
  static const String tagline = 'Grow, collect, climb levels';
  static const String familyCredit = 'Chingalo Family';

  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=$packageId';
  static const String playStoreMarketUrl = 'market://details?id=$packageId';

  /// iOS bundle id (Xcode `PRODUCT_BUNDLE_IDENTIFIER`).
  static const String iosBundleId = 'chingalo.family.snakeApp';

  /// Apple App Store numeric id from App Store Connect.
  /// Leave empty until the listing exists; then open uses search fallback.
  static const String appStoreId = '';

  static String get appStoreUrl {
    if (appStoreId.isEmpty) {
      final searchTerm = Uri.encodeComponent('$appName $familyCredit');
      return 'https://apps.apple.com/search?term=$searchTerm';
    }
    return 'https://apps.apple.com/app/id$appStoreId';
  }

  static String get appStoreDeepLink {
    if (appStoreId.isEmpty) return appStoreUrl;
    return 'itms-apps://apps.apple.com/app/id$appStoreId';
  }

  static const double swipeMinDistance = 28;
  static const double minCellSize = 14;
  static const double maxCellSize = 36;
  static const double desktopMaxBoard = 640;

  /// Bounds for orientation-aware grid sizing.
  static const int minGridColumns = 10;
  static const int maxGridColumns = 36;
  static const int minGridRows = 8;
  static const int maxGridRows = 36;

  static const int totalLevels = 30;
  static const int comboTimeoutMs = 2500;
}
