import 'package:flutter/foundation.dart';
import 'package:snake_app/core/models/dhis_event.dart';
import 'package:snake_app/core/models/game_score.dart';
import 'package:snake_app/core/services/dhis2_event_services.dart';
import 'package:snake_app/core/services/game_score_services.dart';

class GameScoreState with ChangeNotifier {
  bool _isLoading = false;
  List<GameScore> _gameScores = [];

  bool get isLoading => _isLoading;
  List<GameScore> get gameScores => _gameScores;

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
    List<DhisEvent> dhisEvents = await Dhis2EventServices().getAllEvents();
    _gameScores = List<GameScore>.from(
      dhisEvents
          .map((DhisEvent dhisEvent) => GameScore(dhisEvent: dhisEvent))
          .toList(),
    )..sort((a, b) => b.score.compareTo(a.score));
    _isLoading = false;
    notifyListeners();
  }
}
