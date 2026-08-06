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
import 'package:snake_app/core/models/game_mode.dart';
import 'package:snake_app/core/models/grid_metrics.dart';
import 'package:snake_app/core/services/profile_repository.dart';
import 'package:snake_app/core/services/share_score_service.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/core/theme/snake_skins.dart';
import 'package:snake_app/features/game/game_controller.dart';
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
        return _GameSheetScaffold(
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
            return _GameSheetScaffold(
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

    Direction? queuedDirection;
    if (logicalKey == LogicalKeyboardKey.arrowUp || logicalKey == LogicalKeyboardKey.keyW) {
      queuedDirection = Direction.up;
    } else if (logicalKey == LogicalKeyboardKey.arrowDown ||
        logicalKey == LogicalKeyboardKey.keyS) {
      queuedDirection = Direction.down;
    } else if (logicalKey == LogicalKeyboardKey.arrowLeft ||
        logicalKey == LogicalKeyboardKey.keyA) {
      queuedDirection = Direction.left;
    } else if (logicalKey == LogicalKeyboardKey.arrowRight ||
        logicalKey == LogicalKeyboardKey.keyD) {
      queuedDirection = Direction.right;
    }
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
    final velocityX = velocity.dx;
    final velocityY = velocity.dy;
    if (velocityX.abs() < 120 && velocityY.abs() < 120) return;
    if (velocityX.abs() > velocityY.abs()) {
      _queueDirectionWithFeedback(
        velocityX > 0 ? Direction.right : Direction.left,
      );
    } else {
      _queueDirectionWithFeedback(
        velocityY > 0 ? Direction.down : Direction.up,
      );
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
    if (delta.distance < AppConstants.swipeMinDistance) return;
    if (delta.dx.abs() > delta.dy.abs()) {
      _queueDirectionWithFeedback(
        delta.dx > 0 ? Direction.right : Direction.left,
      );
    } else {
      _queueDirectionWithFeedback(
        delta.dy > 0 ? Direction.down : Direction.up,
      );
    }
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
        _GameHud(
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
                      child: _SideStats(
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
                _HudChip(
                  label: context.l10n.score,
                  value: '${engineSnapshot.score}',
                ),
                const SizedBox(height: 8),
                _HudChip(
                  label: context.l10n.level,
                  value: '${engineSnapshot.level}',
                ),
                if (engineSnapshot.comboCount > 1) ...[
                  const SizedBox(height: 8),
                  _HudChip(
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
            child: _SideStats(
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
                          painter: _BoardPainter(
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
                        child: _ScoreFloat(
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

/// Scroll-safe body for pause / game-over sheets (avoids landscape overflow).
class _GameSheetScaffold extends StatelessWidget {
  const _GameSheetScaffold({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class _GameHud extends StatelessWidget {
  const _GameHud({
    required this.score,
    required this.level,
    required this.combo,
    required this.onPause,
  });

  final int score;
  final int level;
  final int combo;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
      child: Row(
        children: [
          _HudChip(label: context.l10n.score, value: '$score'),
          const SizedBox(width: 8),
          _HudChip(label: context.l10n.level, value: '$level'),
          if (combo > 1) ...[
            const SizedBox(width: 8),
            _HudChip(
              label: context.l10n.combo,
              value: context.l10n.comboValue(combo),
              accent: true,
            ),
          ],
          const Spacer(),
          IconButton(
            tooltip: context.l10n.pause,
            onPressed: onPause,
            icon: const Icon(Icons.pause_rounded),
          ),
        ],
      ),
    );
  }
}

class _HudChip extends StatelessWidget {
  const _HudChip({
    required this.label,
    required this.value,
    this.accent = false,
  });

  final String label;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent
            ? AppColors.brandSecondary.withValues(alpha: 0.18)
            : AppColors.brandPrimary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label $value',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: accent ? AppColors.brandSecondary : null,
            ),
      ),
    );
  }
}

class _SideStats extends StatelessWidget {
  const _SideStats({required this.engineSnapshot, required this.levelConfig});

  final SnakeEngineSnapshot engineSnapshot;
  final LevelConfig levelConfig;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.stats, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text(context.l10n.scoreLabelValue(engineSnapshot.score)),
            Text(context.l10n.levelLabelValue(engineSnapshot.level)),
            Text(context.l10n.eatenLabelValue(engineSnapshot.itemsEaten)),
            Text(context.l10n.lastLabelValue(engineSnapshot.food.icon)),
            const Spacer(),
            Text(
              '${levelConfig.speedLabel(context.l10n)}\n${levelConfig.densityLabel(context.l10n)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreFloat extends StatefulWidget {
  const _ScoreFloat({super.key, required this.points, required this.onDone});

  final int points;
  final VoidCallback onDone;

  @override
  State<_ScoreFloat> createState() => _ScoreFloatState();
}

class _ScoreFloatState extends State<_ScoreFloat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animationProgress = _controller.value;
        return Opacity(
          opacity: (1 - animationProgress).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, -40 * animationProgress),
            child: child,
          ),
        );
      },
      child: Center(
        child: Text(
          '+${widget.points}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.brandSecondary,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class _BoardPainter extends CustomPainter {
  _BoardPainter({
    required this.metrics,
    required this.engineSnapshot,
    required this.isDark,
    required this.snakeSkin,
    required this.headPulse,
  });

  final GridMetrics metrics;
  final SnakeEngineSnapshot engineSnapshot;
  final bool isDark;
  final SnakeSkin snakeSkin;
  final double headPulse;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = isDark ? AppColors.darkGridLine : AppColors.lightGridLine
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    for (var rowIndex = 0; rowIndex < metrics.rows; rowIndex++) {
      for (var colIndex = 0; colIndex < metrics.columns; colIndex++) {
        final rect = Rect.fromLTWH(
          colIndex * metrics.cellSize,
          rowIndex * metrics.cellSize,
          metrics.cellSize,
          metrics.cellSize,
        );
        canvas.drawRect(rect, gridPaint);
      }
    }

    // Mode edge cue.
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = engineSnapshot.mode.wrapsEdges ? 2.2 : 1.4
      ..color = engineSnapshot.mode.wrapsEdges
          ? AppColors.brandInfo.withValues(alpha: 0.55)
          : (isDark ? AppColors.darkGridLine : AppColors.lightGridLine);
    if (engineSnapshot.mode.wrapsEdges) {
      const dash = 6.0;
      const gap = 4.0;
      _drawDashedRect(
        canvas,
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
        edgePaint,
        dash,
        gap,
      );
    }

    // Obstacles (maze rocks).
    final rockPaint = Paint()
      ..color = isDark
          ? const Color(0xFF5A4632)
          : const Color(0xFF8B7355);
    final rockHighlight = Paint()
      ..color = AppColors.brandSecondary.withValues(alpha: 0.35);
    for (final cellIndex in engineSnapshot.obstacleCellIndexes) {
      final (rowIndex, columnIndex) = metrics.rowColumnFor(cellIndex);
      final inset = metrics.cellSize * 0.1;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          columnIndex * metrics.cellSize + inset,
          rowIndex * metrics.cellSize + inset,
          metrics.cellSize - inset * 2,
          metrics.cellSize - inset * 2,
        ),
        Radius.circular(metrics.cellSize * 0.18),
      );
      canvas.drawRRect(rect, rockPaint);
      canvas.drawRRect(rect.deflate(metrics.cellSize * 0.08), rockHighlight);
    }

    final bodyPaint = Paint()
      ..color = snakeSkin.body.withValues(alpha: 0.88);
    final stripePaint = Paint()
      ..color = snakeSkin.bodyStripe.withValues(alpha: 0.9);

    for (var segmentIndex = engineSnapshot.snake.length - 1;
        segmentIndex >= 1;
        segmentIndex--) {
      final cellIndex = engineSnapshot.snake[segmentIndex];
      final (rowIndex, columnIndex) = metrics.rowColumnFor(cellIndex);
      final inset = metrics.cellSize * 0.12;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          columnIndex * metrics.cellSize + inset,
          rowIndex * metrics.cellSize + inset,
          metrics.cellSize - inset * 2,
          metrics.cellSize - inset * 2,
        ),
        Radius.circular(metrics.cellSize * 0.28),
      );
      final useStripe =
          snakeSkin.hasStripe && segmentIndex.isOdd;
      canvas.drawRRect(rect, useStripe ? stripePaint : bodyPaint);
    }

    // Head with facing wedge + optional pulse.
    final headCellIndex = engineSnapshot.snake.first;
    final (headRowIndex, headColumnIndex) =
        metrics.rowColumnFor(headCellIndex);
    final headInset = metrics.cellSize * (0.1 - headPulse * 0.02);
    final headRect = Rect.fromLTWH(
      headColumnIndex * metrics.cellSize + headInset,
      headRowIndex * metrics.cellSize + headInset,
      metrics.cellSize - headInset * 2,
      metrics.cellSize - headInset * 2,
    );
    final headPaint = Paint()
      ..shader = LinearGradient(
        colors: [snakeSkin.headLight, snakeSkin.headDark],
      ).createShader(headRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        headRect,
        Radius.circular(metrics.cellSize * 0.3),
      ),
      headPaint,
    );

    // Direction wedge on head.
    final center = headRect.center;
    final tipOffset = metrics.cellSize * 0.28;
    final Offset tip;
    final Offset leftWing;
    final Offset rightWing;
    switch (engineSnapshot.direction) {
      case Direction.up:
        tip = Offset(center.dx, center.dy - tipOffset);
        leftWing = Offset(center.dx - tipOffset * 0.45, center.dy);
        rightWing = Offset(center.dx + tipOffset * 0.45, center.dy);
      case Direction.down:
        tip = Offset(center.dx, center.dy + tipOffset);
        leftWing = Offset(center.dx - tipOffset * 0.45, center.dy);
        rightWing = Offset(center.dx + tipOffset * 0.45, center.dy);
      case Direction.left:
        tip = Offset(center.dx - tipOffset, center.dy);
        leftWing = Offset(center.dx, center.dy - tipOffset * 0.45);
        rightWing = Offset(center.dx, center.dy + tipOffset * 0.45);
      case Direction.right:
        tip = Offset(center.dx + tipOffset, center.dy);
        leftWing = Offset(center.dx, center.dy - tipOffset * 0.45);
        rightWing = Offset(center.dx, center.dy + tipOffset * 0.45);
    }
    final wedgePath = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(leftWing.dx, leftWing.dy)
      ..lineTo(rightWing.dx, rightWing.dy)
      ..close();
    canvas.drawPath(
      wedgePath,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );

    // Soft eye blink (Reduce Motion → pulse 0 keeps eyes open).
    final eyeClosed = headPulse > 0.82;
    if (!eyeClosed) {
      final eyePaint = Paint()..color = const Color(0xFF0B1F1A);
      final eyeRadius = metrics.cellSize * 0.06;
      final eyeSpread = metrics.cellSize * 0.12;
      late final Offset eyeA;
      late final Offset eyeB;
      switch (engineSnapshot.direction) {
        case Direction.up:
          eyeA = Offset(center.dx - eyeSpread, center.dy - eyeSpread * 0.2);
          eyeB = Offset(center.dx + eyeSpread, center.dy - eyeSpread * 0.2);
        case Direction.down:
          eyeA = Offset(center.dx - eyeSpread, center.dy + eyeSpread * 0.2);
          eyeB = Offset(center.dx + eyeSpread, center.dy + eyeSpread * 0.2);
        case Direction.left:
          eyeA = Offset(center.dx - eyeSpread * 0.2, center.dy - eyeSpread);
          eyeB = Offset(center.dx - eyeSpread * 0.2, center.dy + eyeSpread);
        case Direction.right:
          eyeA = Offset(center.dx + eyeSpread * 0.2, center.dy - eyeSpread);
          eyeB = Offset(center.dx + eyeSpread * 0.2, center.dy + eyeSpread);
      }
      canvas.drawCircle(eyeA, eyeRadius, eyePaint);
      canvas.drawCircle(eyeB, eyeRadius, eyePaint);
    }

    final (foodRowIndex, foodColumnIndex) =
        metrics.rowColumnFor(engineSnapshot.foodIndex);
    final foodCenter = Offset(
      foodColumnIndex * metrics.cellSize + metrics.cellSize / 2,
      foodRowIndex * metrics.cellSize + metrics.cellSize / 2,
    );
    final ringColor = switch (engineSnapshot.food.tier) {
      CollectibleTier.common =>
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextMuted,
      CollectibleTier.uncommon => AppColors.brandPrimaryLight,
      CollectibleTier.rare => AppColors.brandSecondary,
      CollectibleTier.epic => AppColors.brandDanger,
    };
    canvas.drawCircle(
      foodCenter,
      metrics.cellSize * 0.38,
      Paint()
        ..color = ringColor.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill,
    );

    final foodIconPainter = TextPainter(
      text: TextSpan(
        text: engineSnapshot.food.icon,
        style: TextStyle(fontSize: metrics.cellSize * 0.62),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    foodIconPainter.paint(
      canvas,
      Offset(
        foodCenter.dx - foodIconPainter.width / 2,
        foodCenter.dy - foodIconPainter.height / 2,
      ),
    );
  }

  void _drawDashedRect(
    Canvas canvas,
    Rect rect,
    Paint paint,
    double dash,
    double gap,
  ) {
    void drawDashedLine(Offset start, Offset end) {
      final total = (end - start).distance;
      if (total == 0) return;
      final direction = (end - start) / total;
      var drawn = 0.0;
      var drawSegment = true;
      while (drawn < total) {
        final segmentLength = drawSegment ? dash : gap;
        final next = (drawn + segmentLength).clamp(0.0, total);
        if (drawSegment) {
          canvas.drawLine(
            start + direction * drawn,
            start + direction * next,
            paint,
          );
        }
        drawn = next;
        drawSegment = !drawSegment;
      }
    }

    drawDashedLine(rect.topLeft, rect.topRight);
    drawDashedLine(rect.topRight, rect.bottomRight);
    drawDashedLine(rect.bottomRight, rect.bottomLeft);
    drawDashedLine(rect.bottomLeft, rect.topLeft);
  }

  @override
  bool shouldRepaint(covariant _BoardPainter oldDelegate) {
    return oldDelegate.engineSnapshot != engineSnapshot ||
        oldDelegate.metrics.cellSize != metrics.cellSize ||
        oldDelegate.isDark != isDark ||
        oldDelegate.snakeSkin.id != snakeSkin.id ||
        oldDelegate.headPulse != headPulse;
  }
}
