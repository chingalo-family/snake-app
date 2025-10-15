import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/modules/game/game.dart';
import 'package:snake_app/modules/leaderboard/leaderboard.dart';
import 'package:snake_app/modules/user_profile/user_profile.dart';

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

  void _onDirectToLeaderboard(BuildContext context) {
    Timer(
      const Duration(microseconds: 500),
      () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => Leaderboard(),
          transitionDuration: const Duration(seconds: 0),
        ),
      ),
    );
  }

  void _onDirectToProfile(BuildContext context) {
    Timer(
      const Duration(microseconds: 500),
      () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => Userprofile(),
          transitionDuration: const Duration(seconds: 0),
        ),
      ),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5.0),
                child: Text("🎮"),
              ),
              Text(AppInfoReference.appName),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      automaticallyImplyLeading: false,
      actions: [
        Visibility(
          child: IconButton(
            icon: Text('🏆'),
            tooltip: 'Leaderboard',
            onPressed: () => _onDirectToLeaderboard(context),
          ),
        ),
        Visibility(
          child: IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            tooltip: 'Profile',
            onPressed: () => _onDirectToProfile(context),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.login,
            color: Colors.white,
          ), //  icon: Icon(Icons.logout, color: Colors.white),// l
          tooltip: 'Login / Logout', //TODO handliing this
          onPressed: () {},
        ),
      ],
    );
  }
}
