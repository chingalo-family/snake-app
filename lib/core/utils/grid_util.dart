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
    int maxRows = ((gamePanelHeight - AppInfoReference.gridPadding) /
            (boxSize + AppInfoReference.gridPadding))
        .floor(); // Use floor instead of toInt to avoid overflow
    
    // Ensure we don't exceed reasonable limits and account for padding
    return maxRows.clamp(10, 50);
  }
}
