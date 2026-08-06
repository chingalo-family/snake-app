import 'package:snake_app/l10n/app_localizations.dart';

enum GameMode {
  
  classic,

  
  wrap,

  
  maze,

  
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
