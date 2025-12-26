/// Model for game achievements to increase engagement
class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int targetValue;
  final AchievementType type;
  bool isUnlocked;
  int currentProgress;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.targetValue,
    required this.type,
    this.isUnlocked = false,
    this.currentProgress = 0,
  });

  double get progress => (currentProgress / targetValue).clamp(0.0, 1.0);

  bool checkAndUnlock(int value) {
    currentProgress = value;
    if (!isUnlocked && currentProgress >= targetValue) {
      isUnlocked = true;
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'targetValue': targetValue,
      'type': type.toString(),
      'isUnlocked': isUnlocked,
      'currentProgress': currentProgress,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      targetValue: json['targetValue'],
      type: AchievementType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => AchievementType.score,
      ),
      isUnlocked: json['isUnlocked'] ?? false,
      currentProgress: json['currentProgress'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Achievement: $title (${(progress * 100).toStringAsFixed(0)}%)';
  }
}

enum AchievementType {
  score,
  streak,
  foodCollected,
  gamesPlayed,
}
