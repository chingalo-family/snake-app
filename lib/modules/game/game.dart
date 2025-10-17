import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/modules/game/components/game_highlight_container.dart';
import 'package:snake_app/modules/game/pages/game_play.dart';
import 'package:snake_app/modules/leaderboard/leaderboard.dart';

class Game extends StatelessWidget {
  const Game({super.key});

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

  void _onDirectToGamePlay(BuildContext context) {
    Timer(
      const Duration(microseconds: 500),
      () => Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => GamePlay(),
          transitionDuration: const Duration(milliseconds: 100),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarContainer(),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.shortestSide * 0.25,
              width: size.shortestSide * 0.25,
              child: const Image(
                fit: BoxFit.contain,
                image: AssetImage('assets/img/app-icon.png'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                AppInfoReference.appName,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Classic Arcade action, Beat the high Score',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            GameHighlightContainer(),
            const SizedBox(height: 20.0),
            FilledButton(
              onPressed: () => _onDirectToGamePlay(context),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                width: size.width * 0.80,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        IconReference.gamePad,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      "Play Now",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            OutlinedButton(
              onPressed: () => _onDirectToLeaderboard(context),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                width: size.width * 0.80,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5.0),
                      child: Text(
                        IconReference.trophy,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      "Leaderboard",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
