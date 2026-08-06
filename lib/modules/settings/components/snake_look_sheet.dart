import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snake_app/app/providers.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';
import 'package:snake_app/core/theme/app_colors.dart';
import 'package:snake_app/core/theme/snake_skins.dart';

Future<void> showSnakeLookSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String selectedSkinId,
}) async {
  final l10n = context.l10n;
  final highestUnlocked =
      ref.read(profileControllerProvider).highestLevelUnlocked;
  final controller = ref.read(settingsControllerProvider.notifier);

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.selectSnakeLook,
                style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.snakeLookSubtitle,
                style: Theme.of(sheetContext).textTheme.bodySmall?.copyWith(
                      color: Theme.of(sheetContext)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.65),
                    ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final skin in SnakeSkinsCatalog.all)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [skin.headLight, skin.headDark],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.brandPrimaryLight
                                  .withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                        title: Text(skin.label(l10n)),
                        subtitle: SnakeSkinsCatalog.isUnlocked(
                          skin,
                          highestUnlocked,
                        )
                            ? null
                            : Text(l10n.skinLockedHint(skin.unlockLevel)),
                        trailing: skin.id == selectedSkinId
                            ? const Icon(
                                Icons.check_rounded,
                                color: AppColors.brandPrimaryLight,
                              )
                            : null,
                        enabled: SnakeSkinsCatalog.isUnlocked(
                          skin,
                          highestUnlocked,
                        ),
                        onTap: SnakeSkinsCatalog.isUnlocked(
                          skin,
                          highestUnlocked,
                        )
                            ? () {
                                controller.setSnakeSkinId(skin.id);
                                Navigator.pop(sheetContext);
                              }
                            : null,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
