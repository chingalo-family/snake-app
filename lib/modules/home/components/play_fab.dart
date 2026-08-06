import 'package:flutter/material.dart';
import 'package:snake_app/core/l10n/l10n_extensions.dart';

class PlayFab extends StatelessWidget {
  const PlayFab({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: context.l10n.play,
      child: const Icon(Icons.play_arrow_rounded),
    );
  }
}
