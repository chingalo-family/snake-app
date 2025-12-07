import 'package:flutter/material.dart';

class AppInfoReference {
  static const String appName = 'Snake App';
  static const String androidId = 'chingalo.family.snake_app';
  static const String currentAppVersion = '1.0.1';
  static const Color defaultAppColor = Colors.cyan;
  static const int gridPadding = 2;
  static const double targetBoxSize =
      15.0; //@TODO Determines the size of each box in the grid, later be depend on levels
  static const int defaultGridColumnsCount = 20;

  static int getGridColumnsCount(double availableWidth) {
    int columns =
        ((availableWidth - gridPadding) / (targetBoxSize + gridPadding))
            .floor();
    return columns.clamp(10, 40);
  }
}
