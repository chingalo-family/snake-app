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
    return (gamePanelWidth - AppInfoReference.gridPadding) / gridColumnsCount -
        AppInfoReference.gridPadding;
  }

  static int getPanelBoxSize(BuildContext context, int gridColumnsCount) {
    double gamePanelWidth = getGamePanelWidth(context);
    double boxSize = _getBoxSize(gamePanelWidth, gridColumnsCount);
    return boxSize.toInt();
  }

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
