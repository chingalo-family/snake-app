import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/profile_avatars.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/shared/widgets/app_chrome.dart';

class ProfileAvatarPicker extends StatelessWidget {
  const ProfileAvatarPicker({
    super.key,
    required this.selectedAvatarId,
    required this.onAvatarSelected,
  });

  final String selectedAvatarId;
  final ValueChanged<String> onAvatarSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SurfaceCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.selectAvatar,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final avatarOption in ProfileAvatarCatalog.all)
                ChoiceChip(
                  label: Text(avatarOption.emoji),
                  selected: avatarOption.id == selectedAvatarId,
                  onSelected: (_) => onAvatarSelected(avatarOption.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
