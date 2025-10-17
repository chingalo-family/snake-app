class GameScore {
  int score;
  String icon;

  GameScore({required this.score, required this.icon});

  @override
  String toString() {
    return 'Score: $score, Icon: $icon';
  }
}
