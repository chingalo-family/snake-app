import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/user_state/user_entry_form_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/modules/contact/contact_us.dart';
import 'package:snake_app/modules/leaderboard/leaderboard.dart';
import 'package:snake_app/modules/settings/settings.dart';
import 'package:snake_app/modules/user/user_profile.dart';
import 'package:snake_app/modules/user/user_sign_in_or_sign_up.dart';

class MoreActionMenu extends StatelessWidget {
  const MoreActionMenu({super.key});

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

  void _onNavigateToSettings(BuildContext context) {
    Navigator.pop(context);
    Timer(
      const Duration(microseconds: 500),
      () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const Settings(),
          transitionDuration: const Duration(seconds: 0),
        ),
      ),
    );
  }

  void _onNavigateToContactUs(BuildContext context) {
    Navigator.pop(context);
    Timer(
      const Duration(microseconds: 500),
      () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ContactUs(),
          transitionDuration: const Duration(seconds: 0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        bool isUserLoggedIn = userState.isUserLoggedIn;
        return SingleChildScrollView(
          child: MaterialCard(
            body: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.0,
                    height: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          icon: Icons.settings_outlined,
                          label: 'Settings',
                          onTap: () => _onNavigateToSettings(context),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.mail_outline,
                          label: 'Contact Us',
                          onTap: () => _onNavigateToContactUs(context),
                        ),
                        _buildMenuItem(
                          context,
                          iconLabel: IconReference.trophy,
                          label: 'Leaderboard',
                          onTap: () => _onDirectToLeaderboard(context),
                        ),
                        Visibility(
                          visible: isUserLoggedIn,
                          child: _buildMenuItem(
                            context,
                            iconLabel: IconReference.person,
                            label: 'Profile',
                            onTap: () => _onDirectToProfile(context),
                          ),
                        ),
                        _buildMenuItem(
                          context,
                          icon: isUserLoggedIn ? Icons.logout : Icons.login,
                          label: isUserLoggedIn ? 'Logout' : 'Login',
                          onTap: () => _onLogin(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    IconData? icon,
    String iconLabel = '',

    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: iconLabel.isEmpty
          ? Icon(icon, color: AppInfoReference.defaultAppColor)
          : Text(iconLabel, style: Theme.of(context).textTheme.headlineSmall),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      hoverColor: AppInfoReference.defaultAppColor.withAlpha(25),
    );
  }
}
