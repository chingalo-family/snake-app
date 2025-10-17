class GameFoodScore {
  int score;
  String icon;

  GameFoodScore({required this.score, required this.icon});

  @override
  String toString() {
    return 'Score: $score, Icon: $icon';
  }
}
