import 'package:snake_app/core/constants/collectibles.dart';
import 'package:snake_app/l10n/app_localizations.dart';
import 'package:snake_app/core/models/game_mode.dart';
import 'package:snake_app/core/models/run_spec.dart';

abstract final class ChallengesCatalog {
  static RunSpec byId(String id, {DateTime? date}) {
    if (id == dailyIdFor(date ?? DateTime.now())) {
      return daily(date ?? DateTime.now());
    }
    for (final spec in all(date ?? DateTime.now())) {
      if (spec.id == id) return spec;
    }
    return all(date ?? DateTime.now()).first;
  }

  static String dailyIdFor(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return 'daily-${date.year}-$month-$day';
  }

  static List<RunSpec> all(DateTime date) {
    return [
      _sprint(id: 'sprint-60', seconds: 60, wrap: false, seed: 1101),
      _sprint(id: 'sprint-90', seconds: 90, wrap: true, seed: 2202),
      _sprint(id: 'sprint-open', seconds: 60, wrap: true, seed: 3303),
      _zen(id: 'zen', wrap: false),
      _zen(id: 'zen-wrap', wrap: true),
      _collector(),
      _bonus(),
      _growing(),
      _burrows(),
      _bitter(),
      _keyLock(),
      _shieldDash(),
      daily(date),
      _hotSeat(),
      _clearGrove(),
      _shed(),
      _peaceful(),
      _fleeing(),
      _lantern(),
      _vine(),
      _mixWrapBitter(),
      _mixMazeBonus(),
      _arena(),
    ];
  }

  static RunSpec daily(DateTime date) {
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final wrap = seed.isEven;
    return RunSpec(
      id: dailyIdFor(date),
      level: 8,
      tickMs: 150,
      columns: 18,
      rows: 22,
      unlockScore: 0,
      mode: wrap ? GameMode.wrap : GameMode.classic,
      walls: wrap ? WallRule.wrap : WallRule.solid,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.bonusCritter,
      objective: ObjectiveKind.timed,
      durationSec: 75,
      seed: seed,
      section: ChallengeSection.today,
    );
  }

  static String title(RunSpec spec, AppLocalizations l10n) {
    return switch (spec.id) {
      'sprint-60' => l10n.challengeSprint60,
      'sprint-90' => l10n.challengeSprint90,
      'sprint-open' => l10n.challengeSprintOpen,
      'zen' => l10n.challengeZen,
      'zen-wrap' => l10n.challengeZenWrap,
      'collector' => l10n.challengeCollector,
      'bonus' => l10n.challengeBonus,
      'growing' => l10n.challengeGrowing,
      'burrows' => l10n.challengeBurrows,
      'bitter' => l10n.challengeBitter,
      'key-lock' => l10n.challengeKey,
      'shield-dash' => l10n.challengeShieldDash,
      'hot-seat' => l10n.challengeHotSeat,
      'clear-grove' => l10n.challengeClearGrove,
      'shed' => l10n.challengeShed,
      'peaceful' => l10n.challengePeaceful,
      'fleeing' => l10n.challengeFleeing,
      'lantern' => l10n.challengeLantern,
      'vine' => l10n.challengeVine,
      'mix-bitter' => l10n.challengeMixBitter,
      'mix-bonus' => l10n.challengeMixBonus,
      'arena' => l10n.challengeArena,
      _ => l10n.challengeDaily,
    };
  }

  static String tip(RunSpec spec, AppLocalizations l10n) {
    return switch (spec.objective) {
      ObjectiveKind.timed => l10n.tipTimed,
      ObjectiveKind.endless => l10n.tipZen,
      ObjectiveKind.collectTargets => l10n.tipCollector,
      ObjectiveKind.eatAll => l10n.tipClearGrove,
      ObjectiveKind.peacefulFill => l10n.tipPeaceful,
      ObjectiveKind.arena => l10n.tipArena,
      ObjectiveKind.scoreGate => l10n.tipScore,
    };
  }

  static String sectionTitle(ChallengeSection section, AppLocalizations l10n) {
    return switch (section) {
      ChallengeSection.timed => l10n.sectionTimed,
      ChallengeSection.practice => l10n.sectionPractice,
      ChallengeSection.board => l10n.sectionBoard,
      ChallengeSection.clutch => l10n.sectionClutch,
      ChallengeSection.today => l10n.sectionToday,
      ChallengeSection.expert => l10n.sectionExpert,
    };
  }

  static RunSpec _sprint({
    required String id,
    required int seconds,
    required bool wrap,
    required int seed,
  }) {
    return RunSpec(
      id: id,
      level: 6,
      tickMs: 140,
      columns: 16,
      rows: 20,
      unlockScore: 0,
      mode: wrap ? GameMode.wrap : GameMode.classic,
      walls: wrap ? WallRule.wrap : WallRule.solid,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.timed,
      durationSec: seconds,
      seed: seed,
      section: ChallengeSection.timed,
    );
  }

  static RunSpec _zen({required String id, required bool wrap}) {
    return RunSpec(
      id: id,
      level: 4,
      tickMs: 170,
      columns: 16,
      rows: 20,
      unlockScore: 0,
      mode: wrap ? GameMode.wrap : GameMode.classic,
      walls: wrap ? WallRule.wrap : WallRule.solid,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.endless,
      section: ChallengeSection.practice,
    );
  }

  static RunSpec _collector() {
    return RunSpec(
      id: 'collector',
      level: 14,
      tickMs: 160,
      columns: 16,
      rows: 18,
      unlockScore: 0,
      mode: GameMode.maze,
      walls: WallRule.solid,
      obstacles: ObstacleRule.staticMaze,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.collectTargets,
      targetTier: CollectibleTier.rare,
      targetCount: 3,
      section: ChallengeSection.practice,
    );
  }

  static RunSpec _bonus() {
    return RunSpec(
      id: 'bonus',
      level: 8,
      tickMs: 150,
      columns: 16,
      rows: 20,
      unlockScore: 0,
      mode: GameMode.classic,
      walls: WallRule.solid,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.bonusCritter,
      objective: ObjectiveKind.endless,
      section: ChallengeSection.board,
    );
  }

  static RunSpec _growing() {
    return RunSpec(
      id: 'growing',
      level: 8,
      tickMs: 160,
      columns: 16,
      rows: 20,
      unlockScore: 0,
      mode: GameMode.classic,
      walls: WallRule.solid,
      obstacles: ObstacleRule.growing,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.endless,
      section: ChallengeSection.board,
    );
  }

  static RunSpec _burrows() {
    return RunSpec(
      id: 'burrows',
      level: 8,
      tickMs: 150,
      columns: 16,
      rows: 18,
      unlockScore: 0,
      mode: GameMode.classic,
      walls: WallRule.solid,
      obstacles: ObstacleRule.none,
      burrows: true,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.endless,
      section: ChallengeSection.board,
    );
  }

  static RunSpec _bitter() {
    return RunSpec(
      id: 'bitter',
      level: 6,
      tickMs: 160,
      columns: 16,
      rows: 20,
      unlockScore: 0,
      mode: GameMode.classic,
      walls: WallRule.solid,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.bitter,
      objective: ObjectiveKind.endless,
      section: ChallengeSection.board,
    );
  }

  static RunSpec _keyLock() {
    return RunSpec(
      id: 'key-lock',
      level: 10,
      tickMs: 160,
      columns: 16,
      rows: 18,
      unlockScore: 0,
      mode: GameMode.maze,
      walls: WallRule.solid,
      obstacles: ObstacleRule.staticMaze,
      foodBehavior: FoodBehavior.keyLock,
      objective: ObjectiveKind.collectTargets,
      targetTier: CollectibleTier.epic,
      targetCount: 1,
      section: ChallengeSection.board,
    );
  }

  static RunSpec _shieldDash() {
    return RunSpec(
      id: 'shield-dash',
      level: 8,
      tickMs: 140,
      columns: 16,
      rows: 20,
      unlockScore: 0,
      mode: GameMode.classic,
      walls: WallRule.solid,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.timed,
      durationSec: 60,
      shieldEnabled: true,
      dashEnabled: true,
      seed: 6161,
      section: ChallengeSection.clutch,
    );
  }

  static RunSpec _hotSeat() {
    return RunSpec(
      id: 'hot-seat',
      level: 6,
      tickMs: 140,
      columns: 16,
      rows: 18,
      unlockScore: 0,
      mode: GameMode.wrap,
      walls: WallRule.wrap,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.timed,
      durationSec: 45,
      hotSeat: true,
      seed: 7171,
      section: ChallengeSection.today,
    );
  }

  static RunSpec _clearGrove() {
    return RunSpec(
      id: 'clear-grove',
      level: 5,
      tickMs: 170,
      columns: 12,
      rows: 14,
      unlockScore: 0,
      mode: GameMode.maze,
      walls: WallRule.solid,
      obstacles: ObstacleRule.staticMaze,
      foodBehavior: FoodBehavior.pellets,
      objective: ObjectiveKind.eatAll,
      section: ChallengeSection.expert,
    );
  }

  static RunSpec _shed() {
    return RunSpec(
      id: 'shed',
      level: 4,
      tickMs: 170,
      columns: 16,
      rows: 20,
      unlockScore: 0,
      mode: GameMode.classic,
      walls: WallRule.solid,
      obstacles: ObstacleRule.shedSkin,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.endless,
      section: ChallengeSection.expert,
    );
  }

  static RunSpec _peaceful() {
    return RunSpec(
      id: 'peaceful',
      level: 3,
      tickMs: 180,
      columns: 10,
      rows: 12,
      unlockScore: 0,
      mode: GameMode.classic,
      walls: WallRule.solid,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.peacefulFill,
      section: ChallengeSection.practice,
    );
  }

  static RunSpec _fleeing() {
    return RunSpec(
      id: 'fleeing',
      level: 8,
      tickMs: 140,
      columns: 16,
      rows: 20,
      unlockScore: 0,
      mode: GameMode.wrap,
      walls: WallRule.wrap,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.fleeing,
      objective: ObjectiveKind.timed,
      durationSec: 60,
      dashEnabled: true,
      seed: 8181,
      section: ChallengeSection.expert,
    );
  }

  static RunSpec _lantern() {
    return RunSpec(
      id: 'lantern',
      level: 8,
      tickMs: 160,
      columns: 16,
      rows: 20,
      unlockScore: 0,
      mode: GameMode.classic,
      walls: WallRule.solid,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.endless,
      visibility: VisibilityRule.lantern,
      section: ChallengeSection.expert,
    );
  }

  static RunSpec _vine() {
    return RunSpec(
      id: 'vine',
      level: 4,
      tickMs: 160,
      columns: 14,
      rows: 16,
      unlockScore: 0,
      mode: GameMode.classic,
      walls: WallRule.solid,
      obstacles: ObstacleRule.vineTrail,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.timed,
      durationSec: 45,
      seed: 9191,
      section: ChallengeSection.expert,
    );
  }

  static RunSpec _mixWrapBitter() {
    return RunSpec(
      id: 'mix-bitter',
      level: 8,
      tickMs: 150,
      columns: 16,
      rows: 18,
      unlockScore: 0,
      mode: GameMode.wrap,
      walls: WallRule.wrap,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.bitter,
      objective: ObjectiveKind.timed,
      durationSec: 60,
      seed: 1212,
      section: ChallengeSection.expert,
    );
  }

  static RunSpec _mixMazeBonus() {
    return RunSpec(
      id: 'mix-bonus',
      level: 13,
      tickMs: 160,
      columns: 16,
      rows: 18,
      unlockScore: 0,
      mode: GameMode.maze,
      walls: WallRule.solid,
      obstacles: ObstacleRule.staticMaze,
      foodBehavior: FoodBehavior.bonusCritter,
      objective: ObjectiveKind.collectTargets,
      targetTier: CollectibleTier.rare,
      targetCount: 2,
      section: ChallengeSection.expert,
    );
  }

  static RunSpec _arena() {
    return RunSpec(
      id: 'arena',
      level: 10,
      tickMs: 150,
      columns: 18,
      rows: 22,
      unlockScore: 0,
      mode: GameMode.wrap,
      walls: WallRule.wrap,
      obstacles: ObstacleRule.none,
      foodBehavior: FoodBehavior.standard,
      objective: ObjectiveKind.arena,
      botCount: 2,
      dashEnabled: true,
      seed: 4242,
      section: ChallengeSection.expert,
    );
  }
}
