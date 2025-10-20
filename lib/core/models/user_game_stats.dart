class UserGameStats {
  final int gamesPlayed;
  final int bestScore;
  final double averageScore;
  final int bestRank;

  UserGameStats({
    required this.gamesPlayed,
    required this.bestScore,
    required this.averageScore,
    required this.bestRank,
  });

  @override
  String toString() {
    return '{ gamesPlayed: $gamesPlayed, bestScore: $bestScore, averageScore: $averageScore, bestRank: $bestRank}';
  }
}
