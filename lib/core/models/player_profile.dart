import 'package:flutter/foundation.dart';
import 'package:snake_app/core/constants/profile_avatars.dart';

@immutable
class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.name,
    required this.avatarId,
    this.email,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String avatarId;
  final String? email;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get initial {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.substring(0, 1).toUpperCase();
  }

  String get avatarEmoji => ProfileAvatarCatalog.byId(avatarId).emoji;

  PlayerProfile copyWith({
    String? name,
    String? avatarId,
    String? email,
    String? phone,
    DateTime? updatedAt,
  }) {
    return PlayerProfile(
      id: id,
      name: name ?? this.name,
      avatarId: avatarId ?? this.avatarId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'full_name': name,
      'avatar_id': avatarId,
      'email': email,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory PlayerProfile.fromMap(Map<String, Object?> map) {
    return PlayerProfile(
      id: map['id']! as int,
      name: map['full_name']! as String,
      avatarId:
          (map['avatar_id'] as String?) ?? ProfileAvatarCatalog.defaultAvatarId,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      createdAt: DateTime.parse(map['created_at']! as String),
      updatedAt: DateTime.parse(map['updated_at']! as String),
    );
  }
}

@immutable
class PlayerProgress {
  const PlayerProgress({
    required this.profileId,
    required this.highestLevelUnlocked,
    required this.gamesPlayed,
    required this.bestOverallScore,
    required this.bestCombo,
  });

  final int profileId;
  final int highestLevelUnlocked;
  final int gamesPlayed;
  final int bestOverallScore;
  final int bestCombo;

  factory PlayerProgress.empty(int profileId) {
    return PlayerProgress(
      profileId: profileId,
      highestLevelUnlocked: 1,
      gamesPlayed: 0,
      bestOverallScore: 0,
      bestCombo: 0,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'profile_id': profileId,
      'highest_level_unlocked': highestLevelUnlocked,
      'games_played': gamesPlayed,
      'best_overall_score': bestOverallScore,
      'best_combo': bestCombo,
    };
  }

  factory PlayerProgress.fromMap(Map<String, Object?> map) {
    return PlayerProgress(
      profileId: map['profile_id']! as int,
      highestLevelUnlocked: map['highest_level_unlocked']! as int,
      gamesPlayed: map['games_played']! as int,
      bestOverallScore: map['best_overall_score']! as int,
      bestCombo: map['best_combo']! as int,
    );
  }
}

@immutable
class HighScoreRecord {
  const HighScoreRecord({
    required this.id,
    required this.profileId,
    required this.level,
    required this.score,
    required this.achievedAt,
  });

  final int id;
  final int profileId;
  final int level;
  final int score;
  final DateTime achievedAt;

  factory HighScoreRecord.fromMap(Map<String, Object?> map) {
    return HighScoreRecord(
      id: map['id']! as int,
      profileId: map['profile_id']! as int,
      level: map['level']! as int,
      score: map['score']! as int,
      achievedAt: DateTime.parse(map['achieved_at']! as String),
    );
  }
}
