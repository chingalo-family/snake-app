import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/core/services/user_service.dart';
import 'package:snake_app/modules/about/about.dart';
import 'package:snake_app/modules/contact/contact_us.dart';
import 'package:snake_app/modules/game/game.dart';
import 'package:snake_app/modules/user/change_password.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Note: These settings currently only update local state.
  // Future implementation should integrate with:
  // - GameSoundService for sound control
  // - Haptic feedback service for vibration control
  bool _soundEnabled = true;
  bool _hapticEnabled = true;

  Widget _buildSettingsSection(
    BuildContext context, {
    required String title,
    required String icon,
    required List<Widget> children,
  }) {
    return MaterialCard(
      elevation: 2.0,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  icon,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 10.0),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Text(
              icon,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      await UserService().logout();
      Provider.of<UserState>(context, listen: false).clearCurrentUser();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Game()),
        (route) => false,
      );
    }
  }

  void _navigateToAbout() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const About(),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _navigateToContactUs() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ContactUs(),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _navigateToChangePassword() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ChangePassword(),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚙️ Settings',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      'Customize your game experience',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
              ),

              // Game Settings
              _buildSettingsSection(
                context,
                title: 'Game Settings',
                icon: IconReference.gamePad,
                children: [
                  _buildSettingItem(
                    title: 'Sound Effects',
                    subtitle: 'Enable background music and sound effects',
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                      // Note: Future implementation will integrate with GameSoundService
                      // to control actual sound playback
                    },
                  ),
                  _buildSettingItem(
                    title: 'Haptic Feedback',
                    subtitle: 'Enable vibration for game actions',
                    value: _hapticEnabled,
                    onChanged: (value) {
                      setState(() {
                        _hapticEnabled = value;
                      });
                      // Note: Future implementation will integrate with haptic feedback
                      // service to control vibrations
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15.0),

              // Account Settings
              Consumer<UserState>(
                builder: (context, userState, child) {
                  bool isUserLoggedIn = userState.isUserLoggedIn;
                  return isUserLoggedIn
                      ? Column(
                          children: [
                            _buildSettingsSection(
                              context,
                              title: 'Account',
                              icon: IconReference.person,
                              children: [
                                _buildNavigationItem(
                                  title: 'Change Password',
                                  icon: '🔐',
                                  onTap: _navigateToChangePassword,
                                ),
                                const Divider(height: 20),
                                _buildNavigationItem(
                                  title: 'Logout',
                                  icon: '🚪',
                                  onTap: _handleLogout,
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                          ],
                        )
                      : const SizedBox.shrink();
                },
              ),

              // Information
              _buildSettingsSection(
                context,
                title: 'Information',
                icon: 'ℹ️',
                children: [
                  _buildNavigationItem(
                    title: 'About ${AppInfoReference.appName}',
                    icon: '📱',
                    onTap: _navigateToAbout,
                  ),
                  const Divider(height: 20),
                  _buildNavigationItem(
                    title: 'Contact Us',
                    icon: '📧',
                    onTap: _navigateToContactUs,
                  ),
                  const Divider(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        const Text(
                          '📦',
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'App Version',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                AppInfoReference.currentAppVersion,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
