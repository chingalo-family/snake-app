import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/user_state/user_entry_form_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/components/more_action_menu.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/core/utils/app_modal_util.dart';
import 'package:snake_app/modules/game/game.dart';
import 'package:snake_app/modules/leaderboard/leaderboard.dart';
import 'package:snake_app/modules/user/user_profile.dart';
import 'package:snake_app/modules/user/user_sign_in_or_sign_up.dart';

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

  void _onDirectToProfile(BuildContext context) {
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
          pageBuilder: (_, __, ___) => UserProfile(),
          transitionDuration: const Duration(seconds: 0),
        ),
      ),
    );
  }

  void _onLogin(BuildContext context) {
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

  void _onLogout(BuildContext context) {
    Provider.of<UserState>(context, listen: false).logoutUser();
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
      initialHeightRatio: 0.2,
      minHeightRatio: 0.1,
      maxHeightRatio: 0.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        bool isUserLoggedIn = userState.isUserLoggedIn;
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
                    margin: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      IconReference.gamePad,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Text(
                    AppInfoReference.appName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: false,
          actions: [
            Visibility(
              child: IconButton(
                icon: Text(
                  IconReference.trophy,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                tooltip: 'Leaderboard',
                onPressed: () => _onDirectToLeaderboard(context),
              ),
            ),
            Visibility(
              visible: isUserLoggedIn,
              child: IconButton(
                icon: Text(
                  IconReference.person,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                tooltip: 'Profile',
                onPressed: () => _onDirectToProfile(context),
              ),
            ),
            IconButton(
              icon: Icon(
                isUserLoggedIn ? Icons.logout : Icons.login,
                color: Colors.white,
              ),
              tooltip: isUserLoggedIn ? 'Logout' : 'Login',
              onPressed: () =>
                  isUserLoggedIn ? _onLogout(context) : _onLogin(context),
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              tooltip: 'More',
              onPressed: () => _onOpenMoreActions(context),
            ),
          ],
        );
      },
    );
  }
}
