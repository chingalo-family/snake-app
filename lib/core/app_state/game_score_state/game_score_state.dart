import 'package:flutter/foundation.dart';
import 'package:snake_app/core/services/game_score_services.dart';

class GameScoreState with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void submitGameScore({required int score, required int level}) async {
    _isLoading = true;
    notifyListeners();
    await GameScoreServices().submitGameScore(score: score, level: level);
    _isLoading = false;
    notifyListeners();
  }

  void resetGameScoreState({required String orgUnitId}) async {
    _isLoading = true;
    notifyListeners();
    await GameScoreServices().downloadGameScoresFromServer(
      orgUnitId: orgUnitId,
    );
    _isLoading = false;
    notifyListeners();
  }
}
