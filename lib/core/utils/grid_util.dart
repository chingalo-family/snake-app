import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';

class GridUtil {
  static double getGamePanelWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static int getGridColumnsCount(BuildContext context) {
    double gamePanelWidth = getGamePanelWidth(context);
    return AppInfoReference.getGridColumnsCount(gamePanelWidth);
  }

  static double _getBoxSize(double gamePanelWidth, int gridColumnsCount) {
    // Use fixed box size for uniform appearance across all devices
    return AppInfoReference.targetBoxSize;
  }

  static int getPanelBoxSize(BuildContext context, int gridColumnsCount) {
    // Return fixed box size for consistent grid across devices
    return AppInfoReference.targetBoxSize.toInt();
  }

  static int getNumberOfRows(
    BuildContext context,
    int gamePanelHeight,
    int gridColumnsCount,
  ) {
    double boxSize = AppInfoReference.targetBoxSize;
    double spacing = 2.0; // Account for mainAxisSpacing in GridView
    
    // Calculate available height after padding
    double availableHeight = gamePanelHeight - AppInfoReference.gridPadding * 2;
    
    // Calculate how many rows can fit: (height) / (boxSize + spacing)
    // Subtract one spacing since the last row doesn't need spacing after it
    int maxRows = ((availableHeight + spacing) / (boxSize + spacing)).floor();
    
    // Ensure we don't exceed reasonable limits
    return maxRows.clamp(10, 50);
  }
}
