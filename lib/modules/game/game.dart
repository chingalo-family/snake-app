import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/snake_state/snake_state.dart';
import 'package:snake_app/core/app_state/user_state/user_entry_form_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/modules/game/components/game_highlight_container.dart';
import 'package:snake_app/modules/game/pages/game_play.dart';
import 'package:snake_app/modules/leaderboard/leaderboard.dart';
import 'package:snake_app/modules/user/user_sign_in_or_sign_up.dart';

class Game extends StatelessWidget {
  const Game({super.key});

  void _onDirectToLeaderboard(BuildContext context) {
    String orgUnitId = Provider.of<UserState>(context, listen: false).orgUnitId;
    Provider.of<GameScoreState>(
      context,
      listen: false,
    ).resetGameScoreState(orgUnitId: orgUnitId);
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
    Provider.of<SnakeState>(context, listen: false).resetSnakeState();
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

  void _onDirectToSignInOrSignUp(BuildContext context) {
    Provider.of<UserEntryFormState>(context, listen: false).resetFormState();
    Timer(
      const Duration(microseconds: 500),
      () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => UserSignInOrSignUp(),
          transitionDuration: const Duration(seconds: 0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarContainer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Section
              MaterialCard(
                elevation: 3.0,
                borderRadius: 16.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.shortestSide * 0.25,
                        width: size.shortestSide * 0.25,
                        child: const Image(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/img/app-icon.png'),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        AppInfoReference.appName,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Classic Arcade action, Beat the high Score',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // Game Highlights
              const SizedBox(height: 20.0),
              GameHighlightContainer(),

              // User Status Card
              const SizedBox(height: 20.0),
              Consumer<UserState>(
                builder: (context, userState, child) {
                  bool isUserLoggedIn = userState.isUserLoggedIn;
                  if (isUserLoggedIn) {
                    return MaterialCard(
                      elevation: 2.0,
                      body: Container(
                        width: size.width * 0.80,
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: Center(
                                child: Text(
                                  userState.usernameIcon.isNotEmpty
                                      ? userState.usernameIcon
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Welcome back!',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 0.0,
                                    ),
                                    height: 45,
                                    child: Text(
                                      userState.currentUser.fullName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            const Icon(
                              Icons.verified,
                              color: AppInfoReference.defaultAppColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Action Buttons
              const SizedBox(height: 20.0),
              Consumer<UserState>(
                builder: (context, userState, child) {
                  bool isUserLoggedIn = userState.isUserLoggedIn;
                  return FilledButton(
                    onPressed: () => isUserLoggedIn
                        ? _onDirectToGamePlay(context)
                        : _onDirectToSignInOrSignUp(context),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width * 0.80,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              IconReference.gamePad,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          Text(
                            isUserLoggedIn ? "Play Now" : "Sign In to Play",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12.0),
              OutlinedButton(
                onPressed: () => _onDirectToLeaderboard(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: size.width * 0.80,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          IconReference.trophy,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      Text(
                        "Leaderboard",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
