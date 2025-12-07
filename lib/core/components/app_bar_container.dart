import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake_app/core/components/more_action_menu.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/core/utils/app_modal_util.dart';
import 'package:snake_app/modules/game/game.dart';

class AppBarContainer extends StatelessWidget implements PreferredSizeWidget {
  const AppBarContainer({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _onDirectToHome(BuildContext context) {
    Timer(
      const Duration(microseconds: 500),
      () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => Game(),
          transitionDuration: const Duration(seconds: 0),
        ),
      ),
    );
  }

  void _onOpenMoreActions(BuildContext context) {
    AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: const MoreActionMenu(),
      initialHeightRatio: 0.3,
      minHeightRatio: 0.1,
      maxHeightRatio: 0.6,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        child: TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          onPressed: () => _onDirectToHome(context),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: Text(
                  IconReference.gamePad,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: Text(
                  AppInfoReference.appName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          tooltip: 'More',
          onPressed: () => _onOpenMoreActions(context),
        ),
      ],
    );
  }
}
