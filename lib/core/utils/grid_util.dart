import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';

/// Utility class for grid-related calculations in the game.
class GridUtil {
  /// Calculate the game panel width based on the screen width.
  static double getGamePanelWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.95;
  }

  /// Calculate the number of grid columns based on the available width.
  static int getGridColumnsCount(BuildContext context) {
    double gamePanelWidth = getGamePanelWidth(context);
    return AppInfoReference.getGridColumnsCount(gamePanelWidth);
  }

  /// Calculate the size of each box in the grid.
  static double _getBoxSize(double gamePanelWidth, int gridColumnsCount) {
    return (gamePanelWidth - AppInfoReference.gridPadding) / gridColumnsCount -
        AppInfoReference.gridPadding;
  }

  /// Calculate the size of each box in the grid as an integer.
  static int getPanelBoxSize(BuildContext context, int gridColumnsCount) {
    double gamePanelWidth = getGamePanelWidth(context);
    return _getBoxSize(gamePanelWidth, gridColumnsCount).toInt();
  }

  /// Calculate the number of rows based on the panel height.
  static int getNumberOfRows(
    BuildContext context,
    int gamePanelHeight,
    int gridColumnsCount,
  ) {
    double gamePanelWidth = getGamePanelWidth(context);
    double boxSize = _getBoxSize(gamePanelWidth, gridColumnsCount);
    return ((gamePanelHeight - AppInfoReference.gridPadding) /
            (boxSize + AppInfoReference.gridPadding))
        .toInt();
  }
}
