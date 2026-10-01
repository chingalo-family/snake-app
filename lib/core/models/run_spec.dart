import 'package:snake_app/core/constants/collectibles.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/models/game_mode.dart';

enum WallRule { solid, wrap }

enum ObstacleRule { none, staticMaze, growing, shedSkin, vineTrail }

enum FoodBehavior { standard, bitter, fleeing, bonusCritter, pellets, keyLock }

enum ObjectiveKind {
  scoreGate,
  timed,
  collectTargets,
  endless,
  eatAll,
  peacefulFill,
  arena,
}

enum VisibilityRule { full, lantern }

enum ChallengeSection { timed, practice, board, clutch, today, expert }

class RunSpec {
  const RunSpec({
    required this.id,
    required this.level,
    required this.tickMs,
    required this.columns,
    required this.rows,
    required this.unlockScore,
    required this.mode,
    required this.walls,
    required this.obstacles,
    required this.foodBehavior,
    required this.objective,
    this.burrows = false,
    this.durationSec = 0,
    this.targetTier = CollectibleTier.rare,
    this.targetCount = 0,
    this.shieldEnabled = false,
    this.dashEnabled = false,
    this.visibility = VisibilityRule.full,
    this.seed,
    this.botCount = 0,
    this.hotSeat = false,
    this.section = ChallengeSection.timed,
  });

  final String id;
  final int level;
  final int tickMs;
  final int columns;
  final int rows;
  final int unlockScore;
  final GameMode mode;
  final WallRule walls;
  final ObstacleRule obstacles;
  final bool burrows;
  final FoodBehavior foodBehavior;
  final ObjectiveKind objective;
  final int durationSec;
  final CollectibleTier targetTier;
  final int targetCount;
  final bool shieldEnabled;
  final bool dashEnabled;
  final VisibilityRule visibility;
  final int? seed;
  final int botCount;
  final bool hotSeat;
  final ChallengeSection section;

  bool get wrapsEdges => walls == WallRule.wrap;

  bool get isCampaign => id.startsWith('level-');

  factory RunSpec.campaign(LevelConfig config) {
    final wraps = config.mode.wrapsEdges;
    final maze = config.mode.hasObstacles;
    return RunSpec(
      id: 'level-${config.level}',
      level: config.level,
      tickMs: config.tickMs,
      columns: config.columns,
      rows: config.rows,
      unlockScore: config.unlockScore,
      mode: config.mode,
      walls: wraps ? WallRule.wrap : WallRule.solid,
      obstacles: maze ? ObstacleRule.staticMaze : ObstacleRule.none,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.scoreGate,
      section: ChallengeSection.practice,
    );
  }
}
