import 'package:flutter/foundation.dart';
import 'package:snake_app/core/models/game_score.dart';
import 'package:snake_app/core/models/user_game_stats.dart';
import 'package:snake_app/core/services/dhis2_event_services.dart';
import 'package:snake_app/core/services/game_score_service.dart';
import 'package:snake_app/core/services/user_service.dart';

class GameScoreState with ChangeNotifier {
  bool _isLoading = false;
  String _gamesPlayed = '-';
  String _bestScore = '-';
  String _averageScore = '-';
  String _bestRank = '-';

  List<GameScore> _gameScores = [];

  bool get isLoading => _isLoading;
  String get gamesPlayed => _gamesPlayed;
  String get bestScore => _bestScore;
  String get averageScore => _averageScore;
  String get bestRank => _bestRank;
  List<GameScore> get gameScores => _gameScores;

  Future<void> submitGameScore({
    required int score,
    required int level,
    required String gameScoreId,
    required String bestScore,
  }) async {
    _setLoading(true);
    await GameScoreService().submitGameScore(
      score: score,
      level: level,
      bestScore: bestScore,
      gameScoreId: gameScoreId,
    );
    _setLoading(false);
  }

  Future<void> resetGameScoreState({required String orgUnitId}) async {
    _setLoading(true);
    await GameScoreService().downloadGameScoresFromServer(orgUnitId: orgUnitId);
    final dhisEvents = await Dhis2EventServices().getAllEvents();
    _gameScores = dhisEvents.map((e) => GameScore(dhisEvent: e)).toList()
      ..sort((a, b) {
        final levelCompare = b.level.compareTo(a.level);
        if (levelCompare != 0) return levelCompare;
        return b.score.compareTo(a.score);
      });
    await _setCurrentUserGameStats();
    _setLoading(false);
  }

  Future<void> _setCurrentUserGameStats() async {
    _resetStats();
    final currentUser = await UserService().getCurrentUser();
    if (currentUser == null) {
      notifyListeners();
      return;
    }
    final user = currentUser.username;
    final stats = _getUserStats(user);
    if (stats != null) {
      _gamesPlayed = stats.gamesPlayed.toString();
      _bestScore = stats.bestScore.toString();
      _averageScore = stats.averageScore.toStringAsFixed(1);
      _bestRank = stats.bestRank.toString();
    }
    notifyListeners();
  }

  UserGameStats? _getUserStats(String user) {
    final userScores = _gameScores.where((gs) => gs.user == user).toList();
    if (userScores.isEmpty) return null;
    final scores = userScores.map((gameScore) => gameScore.score).toList();
    final bestScore = scores.reduce((a, b) => a > b ? a : b);
    final averageScore = scores.reduce((a, b) => a + b) / scores.length;
    final bestRank =
        _gameScores.indexWhere(
          (gameScore) => gameScore.user == user && gameScore.score == bestScore,
        ) +
        1;
    return UserGameStats(
      gamesPlayed: userScores.length,
      bestScore: bestScore,
      averageScore: averageScore,
      bestRank: bestRank,
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _resetStats() {
    _gamesPlayed = _bestScore = _averageScore = _bestRank = '-';
  }
}
