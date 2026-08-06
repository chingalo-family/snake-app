import 'package:snake_app/l10n/app_localizations.dart';

/// Campaign wall / obstacle rule set for a level.
enum GameMode {
  /// Solid edges — leaving the board ends the run.
  classic,

  /// Edges loop to the opposite side; self-collision still ends the run.
  wrap,

  /// Solid edges plus internal blocker cells.
  maze,

  /// Wrap edges plus internal blocker cells (expert band).
  wrapMaze,
}

extension GameModeHelpers on GameMode {
  bool get wrapsEdges => this == GameMode.wrap || this == GameMode.wrapMaze;

  bool get hasObstacles => this == GameMode.maze || this == GameMode.wrapMaze;

  String label(AppLocalizations l10n) => switch (this) {
        GameMode.classic => l10n.modeClassic,
        GameMode.wrap => l10n.modeWrap,
        GameMode.maze => l10n.modeMaze,
        GameMode.wrapMaze => l10n.modeWrapMaze,
      };

  String tip(AppLocalizations l10n) => switch (this) {
        GameMode.classic => l10n.modeClassicTip,
        GameMode.wrap => l10n.modeWrapTip,
        GameMode.maze => l10n.modeMazeTip,
        GameMode.wrapMaze => l10n.modeWrapMazeTip,
      };
}
