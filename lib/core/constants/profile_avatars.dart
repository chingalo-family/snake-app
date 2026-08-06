abstract final class ProfileAvatarCatalog {
  static const String defaultAvatarId = 'snake';

  static const List<ProfileAvatarOption> all = [
    ProfileAvatarOption(id: 'snake', emoji: '🐍'),
    ProfileAvatarOption(id: 'lion', emoji: '🦁'),
    ProfileAvatarOption(id: 'tiger', emoji: '🐯'),
    ProfileAvatarOption(id: 'panda', emoji: '🐼'),
    ProfileAvatarOption(id: 'koala', emoji: '🐨'),
    ProfileAvatarOption(id: 'fox', emoji: '🦊'),
    ProfileAvatarOption(id: 'frog', emoji: '🐸'),
    ProfileAvatarOption(id: 'dolphin', emoji: '🐬'),
    ProfileAvatarOption(id: 'eagle', emoji: '🦅'),
    ProfileAvatarOption(id: 'owl', emoji: '🦉'),
  ];

  static ProfileAvatarOption byId(String? avatarId) {
    if (avatarId == null) return all.first;
    return all.firstWhere(
      (avatarOption) => avatarOption.id == avatarId,
      orElse: () => all.first,
    );
  }
}

class ProfileAvatarOption {
  const ProfileAvatarOption({
    required this.id,
    required this.emoji,
  });

  final String id;
  final String emoji;
}
