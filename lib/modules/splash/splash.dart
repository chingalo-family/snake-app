import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/app_update_state/app_update_state.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/user_state/user_entry_form_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/components/app_update_dialog.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/models/user.dart';
import 'package:snake_app/core/services/app_update_service.dart';
import 'package:snake_app/core/services/dhis2_http_service.dart';
import 'package:snake_app/core/services/user_service.dart';
import 'package:snake_app/modules/game/game.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _hasCheckedForUpdate = false;

  @override
  void initState() {
    super.initState();
    setAppAndInitialData();
  }

  setAppAndInitialData() async {
    User? user = await UserService().getCurrentUser();
    setDataForLandingPage(user);
  }

  void setDataForLandingPage(User? user) async {
    if (user != null && user.isLogin) {
      Provider.of<UserState>(context, listen: false).setCurrentUser(user);
      String orgUnitId = Provider.of<UserState>(
        context,
        listen: false,
      ).orgUnitId;
      Provider.of<GameScoreState>(
        context,
        listen: false,
      ).resetGameScoreState(orgUnitId: orgUnitId);

      // Check for updates only if user is logged in
      await _checkForUpdates(user);
    } else {
      Provider.of<UserEntryFormState>(context, listen: false).resetFormState();
      // Navigate to game after a short delay if not logged in
      _navigateToGame();
    }
  }

  Future<void> _checkForUpdates(User user) async {
    if (_hasCheckedForUpdate) return;
    _hasCheckedForUpdate = true;

    try {
      final dhis2HttpService = Dhis2HttpService(
        username: user.username,
        password: user.password ?? '',
      );
      final updateService = AppUpdateService(
        dhis2HttpService: dhis2HttpService,
      );

      final updateState = Provider.of<AppUpdateState>(context, listen: false);

      await updateState.checkForUpdate(updateService);

      if (mounted && updateState.status == AppUpdateStatus.updateAvailable) {
        // Show update dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AppUpdateDialog(updateService: updateService),
        );
      }
    } catch (e) {
      // Silently fail if update check fails
    }

    // Navigate to game after update check
    if (mounted) {
      _navigateToGame();
    }
  }

  void _navigateToGame() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => Game(),
            transitionDuration: const Duration(seconds: 0),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.4,
                        width: size.width * 0.3,
                        child: const Image(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/img/app-icon.png'),
                        ),
                      ),
                      const CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation(
                          AppInfoReference.defaultAppColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
