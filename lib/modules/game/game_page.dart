import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/bootstrap/desktop_window.dart';
import 'package:snake_app/core/constants/app_constants.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/constants/collectibles.dart';
import 'package:snake_app/core/constants/levels.dart';
import 'package:snake_app/core/game/snake_engine.dart';
import 'package:snake_app/core/models/direction.dart';
import 'package:snake_app/core/models/grid_metrics.dart';
import 'package:snake_app/core/services/profile_repository.dart';
import 'package:snake_app/core/services/share_score_service.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/core/theme/snake_skins.dart';
import 'package:snake_app/modules/game/components/board_painter.dart';
import 'package:snake_app/modules/game/components/game_hud.dart';
import 'package:snake_app/modules/game/components/game_sheet_scaffold.dart';
import 'package:snake_app/modules/game/components/hud_chip.dart';
import 'package:snake_app/modules/game/components/score_float.dart';
import 'package:snake_app/modules/game/components/side_stats.dart';
import 'package:snake_app/modules/game/game_controller.dart';
import 'package:snake_app/modules/game/utils/game_input_utils.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';
import 'package:snake_app/shared/widgets/share_score_card.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key, required this.level});

  final int level;

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage>
    with SingleTickerProviderStateMixin {
  late final GameController _controller;
  late final FocusNode _focusNode;
  late final AnimationController _headPulseController;
  ScoreSubmitResult? _submitResult;
  bool _submitted = false;
  int? _floatPoints;
  int _floatToken = 0;
  Size? _lastBoardSize;
  int _highestBeforeRun = 1;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _controller = GameController(level: widget.level);
    _focusNode = FocusNode();
    _headPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _controller.addListener(_onGameTick);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _highestBeforeRun =
          ref.read(profileControllerProvider).highestLevelUnlocked;
      _focusNode.requestFocus();
      _controller.start();
    });
  }

  void _onGameTick() {
    final eatEvent = _controller.lastEatEvent;
    if (eatEvent != null) {
      _handleEat(eatEvent);
    }
    if (_controller.snapshot.phase == GamePhase.gameOver && !_submitted) {
      _submitted = true;
      _onGameOver();
    }
    setState(() {});
  }

  Future<void> _handleEat(EatEvent eatEvent) async {
    final audio = ref.read(audioServiceProvider);
    final haptics = ref.read(hapticServiceProvider);
    final isHighValueCollectible = eatEvent.collectible.tier == CollectibleTier.rare ||
        eatEvent.collectible.tier == CollectibleTier.epic;
    await audio.playSfx(isHighValue: isHighValueCollectible);
    if (isHighValueCollectible) {
      await haptics.medium();
    } else {
      await haptics.light();
    }
    setState(() {
      _floatPoints = eatEvent.points;
      _floatToken++;
    });
  }

  Future<void> _onGameOver() async {
    final engineSnapshot = _controller.snapshot;
    await ref.read(audioServiceProvider).playCollision();
    await ref.read(hapticServiceProvider).heavy();
    final result = await ref.read(profileControllerProvider.notifier).submitRun(
          level: engineSnapshot.level,
          score: engineSnapshot.score,
          bestCombo: engineSnapshot.bestCombo,
        );
    if (!mounted) return;
    setState(() => _submitResult = result);
    await _showGameOverSheet();
  }

  Future<void> _showPauseSheet() async {
    _controller.pause();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return GameSheetScaffold(
          children: [
            Text(
              sheetContext.l10n.paused,
              style: Theme.of(sheetContext).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.pop(sheetContext);
                _controller.resume();
                _focusNode.requestFocus();
              },
              child: Text(sheetContext.l10n.resume),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(sheetContext);
                _submitted = false;
                _submitResult = null;
                _controller.restart();
                _focusNode.requestFocus();
              },
              child: Text(sheetContext.l10n.restart),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(sheetContext);
                context.go(AppRoutes.levels);
              },
              child: Text(sheetContext.l10n.quitToLevels),
            ),
          ],
        );
      },
    ).whenComplete(() {
      if (_controller.snapshot.phase == GamePhase.paused) {
        _controller.resume();
        _focusNode.requestFocus();
      }
    });
  }

  Future<void> _showGameOverSheet() async {
    final engineSnapshot = _controller.snapshot;
    final hasProfile = ref.read(profileControllerProvider).hasProfile;
    final result = _submitResult;
    final settings = ref.read(settingsControllerProvider);
    final unlockedSkins = result == null
        ? const <SnakeSkin>[]
        : SnakeSkinsCatalog.unlockedBetween(
            previousHighest: _highestBeforeRun,
            nextHighest: result.highestUnlocked,
          );

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return GameSheetScaffold(
              children: [
                Text(
                  sheetContext.l10n.gameOver,
                  style:
                      Theme.of(sheetContext).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.brandDanger,
                          ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${sheetContext.l10n.scoreLevelSummary(engineSnapshot.score, engineSnapshot.level)}'
                  '${engineSnapshot.bestCombo > 1 ? sheetContext.l10n.bestComboSuffix(engineSnapshot.bestCombo) : ''}',
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
                if (result?.isNewBest == true) ...[
                  const SizedBox(height: 8),
                  Text(
                    sheetContext.l10n.newPersonalBest,
                    style:
                        Theme.of(sheetContext).textTheme.titleSmall?.copyWith(
                              color: AppColors.brandSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                  ),
                ],
                if (result?.unlockedNext == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    sheetContext.l10n
                        .levelUnlockedBanner(result!.highestUnlocked),
                    style:
                        Theme.of(sheetContext).textTheme.titleSmall?.copyWith(
                              color: AppColors.brandPrimaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                  ),
                ],
                for (final skin in unlockedSkins) ...[
                  const SizedBox(height: 4),
                  Text(
                    sheetContext.l10n
                        .skinUnlockedBanner(skin.label(sheetContext.l10n)),
                    style:
                        Theme.of(sheetContext).textTheme.titleSmall?.copyWith(
                              color: AppColors.brandSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                  ),
                ],
                if (engineSnapshot.score > 0) ...[
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _isSharing
                        ? null
                        : () async {
                            setSheetState(() => _isSharing = true);
                            await _shareScore(
                              sheetContext: sheetContext,
                              engineSnapshot: engineSnapshot,
                              skin: settings.snakeSkin,
                              unlockedSkins: unlockedSkins,
                              result: result,
                            );
                            if (mounted) {
                              setSheetState(() => _isSharing = false);
                            }
                          },
                    icon: _isSharing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.image_outlined),
                    label: Text(
                      _isSharing
                          ? sheetContext.l10n.sharePreparing
                          : sheetContext.l10n.shareScore,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                if (!hasProfile)
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      context.push(AppRoutes.profile);
                    },
                    child: Text(sheetContext.l10n.saveScoreCreateProfile),
                  )
                else
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _submitted = false;
                      _submitResult = null;
                      _highestBeforeRun = ref
                          .read(profileControllerProvider)
                          .highestLevelUnlocked;
                      _controller.restart();
                      _focusNode.requestFocus();
                    },
                    child: Text(sheetContext.l10n.playAgain),
                  ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    context.go(AppRoutes.levels);
                  },
                  child: Text(sheetContext.l10n.backToLevels),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _shareScore({
    required BuildContext sheetContext,
    required SnakeEngineSnapshot engineSnapshot,
    required SnakeSkin skin,
    required List<SnakeSkin> unlockedSkins,
    required ScoreSubmitResult? result,
  }) async {
    final l10n = sheetContext.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final profile = ref.read(profileControllerProvider).profile;
    try {
      if (!mounted) return;
      final outcome =
          await ref.read(shareScoreServiceProvider).shareSocialPostImage(
                context: context,
                card: ShareScoreCard(
                  score: engineSnapshot.score,
                  level: engineSnapshot.level,
                  mode: engineSnapshot.mode,
                  skin: skin,
                  isNewBest: result?.isNewBest == true,
                  unlockedLevel: result?.unlockedNext == true
                      ? result!.highestUnlocked
                      : null,
                  unlockedSkinLabels: unlockedSkins
                      .map((unlockedSkin) => unlockedSkin.label(l10n))
                      .toList(),
                  playerName: profile?.name,
                  playerAvatarEmoji: profile?.avatarEmoji,
                ),
                shareText: l10n.shareTextCaption(
                  engineSnapshot.score,
                  engineSnapshot.level,
                ),
              );
      if (!mounted) return;
      switch (outcome) {
        case ShareScoreOutcome.cancelled:
        case ShareScoreOutcome.shared:
          break;
        case ShareScoreOutcome.savedToDisk:
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.shareSavedToDisk)),
          );
        case ShareScoreOutcome.failed:
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.shareFailed)),
          );
      }
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.shareFailed)),
      );
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final logicalKey = event.logicalKey;
    if (logicalKey == LogicalKeyboardKey.escape || logicalKey == LogicalKeyboardKey.space) {
      if (_controller.snapshot.phase == GamePhase.running) {
        _showPauseSheet();
      } else if (_controller.snapshot.phase == GamePhase.paused) {
        _controller.resume();
      }
      return KeyEventResult.handled;
    }
    if (logicalKey == LogicalKeyboardKey.enter &&
        _controller.snapshot.phase == GamePhase.gameOver) {
      _submitted = false;
      _submitResult = null;
      _controller.restart();
      return KeyEventResult.handled;
    }

    final queuedDirection = directionFromLogicalKey(logicalKey);
    if (queuedDirection != null) {
      _queueDirectionWithFeedback(queuedDirection);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _queueDirectionWithFeedback(Direction direction) {
    final accepted = _controller.queueDirection(direction);
    if (!accepted) {
      ref.read(hapticServiceProvider).light();
    }
  }

  void _onSwipe(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    final queuedDirection = directionFromSwipeVelocity(
      velocityX: velocity.dx,
      velocityY: velocity.dy,
    );
    if (queuedDirection != null) {
      _queueDirectionWithFeedback(queuedDirection);
    }
  }

  Offset? _panStart;

  void _onPanStart(DragStartDetails details) {
    _panStart = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final start = _panStart;
    if (start == null) return;
    final delta = details.localPosition - start;
    final queuedDirection = directionFromPanDelta(
      delta: delta,
      minDistance: AppConstants.swipeMinDistance,
    );
    if (queuedDirection == null) return;
    _queueDirectionWithFeedback(queuedDirection);
    _panStart = details.localPosition;
  }

  @override
  void dispose() {
    _controller.removeListener(_onGameTick);
    _controller.dispose();
    _focusNode.dispose();
    _headPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final engineSnapshot = _controller.snapshot;
    final levelConfig = LevelsCatalog.byLevel(widget.level);
    final showHints = ref.watch(settingsControllerProvider).showControlHints;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mediaSize = MediaQuery.sizeOf(context);
    final isLandscape = mediaSize.width > mediaSize.height;
    final isWideLayout = mediaSize.width >= 900;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showPauseSheet();
      },
      child: Scaffold(
        body: AtmosphereBackground(
          child: Focus(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: _onKey,
            child: SafeArea(
              child: isLandscape
                  ? _buildLandscapePlayground(
                      engineSnapshot: engineSnapshot,
                      levelConfig: levelConfig,
                      showHints: showHints,
                      isDark: isDark,
                    )
                  : _buildPortraitPlayground(
                      engineSnapshot: engineSnapshot,
                      levelConfig: levelConfig,
                      showHints: showHints,
                      isDark: isDark,
                      isWideLayout: isWideLayout,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitPlayground({
    required SnakeEngineSnapshot engineSnapshot,
    required LevelConfig levelConfig,
    required bool showHints,
    required bool isDark,
    required bool isWideLayout,
  }) {
    return Column(
      children: [
        GameHud(
          score: engineSnapshot.score,
          level: engineSnapshot.level,
          combo: engineSnapshot.comboCount,
          onPause: _showPauseSheet,
        ),
        if (showHints && engineSnapshot.itemsEaten < 3)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              isDesktopPlatform
                  ? context.l10n.hintKeyboard
                  : context.l10n.hintSwipe,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.55),
                  ),
            ),
          ),
        Expanded(
          child: isWideLayout
              ? Row(
                  children: [
                    SizedBox(
                      width: 160,
                      child: SideStats(
                        engineSnapshot: engineSnapshot,
                        levelConfig: levelConfig,
                      ),
                    ),
                    Expanded(child: _buildBoard(engineSnapshot, isDark)),
                  ],
                )
              : _buildBoard(engineSnapshot, isDark),
        ),
      ],
    );
  }

  Widget _buildLandscapePlayground({
    required SnakeEngineSnapshot engineSnapshot,
    required LevelConfig levelConfig,
    required bool showHints,
    required bool isDark,
  }) {
    final mediaWidth = MediaQuery.sizeOf(context).width;
    final showSideStats = mediaWidth >= 700;
    final railWidth = mediaWidth < 700 ? 92.0 : 120.0;

    return Row(
      children: [
        SizedBox(
          width: railWidth,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HudChip(
                  label: context.l10n.score,
                  value: '${engineSnapshot.score}',
                ),
                const SizedBox(height: 8),
                HudChip(
                  label: context.l10n.level,
                  value: '${engineSnapshot.level}',
                ),
                if (engineSnapshot.comboCount > 1) ...[
                  const SizedBox(height: 8),
                  HudChip(
                    label: context.l10n.combo,
                    value: context.l10n.comboValue(engineSnapshot.comboCount),
                    accent: true,
                  ),
                ],
                const Spacer(),
                if (showHints && engineSnapshot.itemsEaten < 3)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      isDesktopPlatform
                          ? context.l10n.hintKeyboard
                          : context.l10n.hintSwipe,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.55),
                          ),
                    ),
                  ),
                IconButton(
                  tooltip: context.l10n.pause,
                  onPressed: _showPauseSheet,
                  icon: const Icon(Icons.pause_rounded),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _buildBoard(engineSnapshot, isDark)),
        if (showSideStats)
          SizedBox(
            width: railWidth,
            child: SideStats(
              engineSnapshot: engineSnapshot,
              levelConfig: levelConfig,
            ),
          ),
      ],
    );
  }

  Widget _buildBoard(SnakeEngineSnapshot engineSnapshot, bool isDark) {
    final levelConfig = LevelsCatalog.byLevel(widget.level);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final maxWidth = constraints.maxWidth - 16;
        final maxHeight = constraints.maxHeight - 16;

        final targetMetrics = GridMetrics.fromConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          baseColumns: levelConfig.columns,
          baseRows: levelConfig.rows,
        );

        final gridChanged =
            targetMetrics.columns != engineSnapshot.columns ||
            targetMetrics.rows != engineSnapshot.rows;
        final sizeChanged = _lastBoardSize != null &&
            ((_lastBoardSize!.width - size.width).abs() > 8 ||
                (_lastBoardSize!.height - size.height).abs() > 8);
        _lastBoardSize = size;

        if (gridChanged || sizeChanged) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (gridChanged) {
              _controller.applyGridSize(
                columns: targetMetrics.columns,
                rows: targetMetrics.rows,
              );
            } else {
              _controller.onLayoutChanged();
            }
          });
        }

        final metrics = gridChanged
            ? GridMetrics.fitFixedGrid(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
                columns: engineSnapshot.columns,
                rows: engineSnapshot.rows,
              )
            : targetMetrics;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onSwipe,
          child: Center(
            child: SizedBox(
              width: metrics.boardWidth,
              height: metrics.boardHeight,
              child: Stack(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBoard : AppColors.lightBoard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkGridLine
                            : AppColors.lightGridLine,
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: _headPulseController,
                      builder: (context, child) {
                        final reduceMotion =
                            MediaQuery.disableAnimationsOf(context);
                        final snakeSkin =
                            ref.watch(settingsControllerProvider).snakeSkin;
                        return CustomPaint(
                          size: Size(metrics.boardWidth, metrics.boardHeight),
                          painter: BoardPainter(
                            metrics: metrics,
                            engineSnapshot: engineSnapshot,
                            isDark: isDark,
                            snakeSkin: snakeSkin,
                            headPulse: reduceMotion
                                ? 0.0
                                : _headPulseController.value,
                          ),
                        );
                      },
                    ),
                  ),
                  if (_floatPoints != null)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: ScoreFloat(
                          key: ValueKey(_floatToken),
                          points: _floatPoints!,
                          onDone: () {
                            if (mounted) setState(() => _floatPoints = null);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
