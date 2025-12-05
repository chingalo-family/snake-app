import 'package:flutter/material.dart';

class AppInfoReference {
  static const String appName = 'Snake App';
  static const String androidId = 'chingalo.family.snake_app';
  static const String currentAppVersion = '1.0.0';
  static const Color defaultAppColor = Colors.cyan;
  static const int gridPadding = 10;
  static const double targetBoxSize = 18.0;

  /// Calculate the number of grid columns based on the available width
  /// to ensure uniform box sizes across different devices.
  static int getGridColumnsCount(double availableWidth) {
    // Calculate how many columns can fit with the target box size
    // Formula: (availableWidth - padding) / (targetBoxSize + padding)
    int columns =
        ((availableWidth - gridPadding) / (targetBoxSize + gridPadding))
            .floor();
    // Ensure at least 10 columns and at most 40 columns
    return columns.clamp(10, 40);
  }
}
