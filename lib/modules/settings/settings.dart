import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/core/services/game_settings_service.dart';
import 'package:snake_app/core/services/game_sound_service.dart';
import 'package:snake_app/modules/about/about.dart';
import 'package:snake_app/modules/contact/contact_us.dart';
import 'package:snake_app/modules/privacy/privacy_policy.dart';
import 'package:snake_app/modules/settings/components/settings_header.dart';
import 'package:snake_app/modules/settings/components/settings_section.dart';
import 'package:snake_app/modules/settings/components/setting_navigation_item.dart';
import 'package:snake_app/modules/settings/components/setting_toggle_item.dart';
import 'package:snake_app/modules/user/change_password.dart';
import 'package:snake_app/modules/user/user_profile.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final soundEnabled = await GameSettingsService.getSoundEffectsEnabled();
    final hapticEnabled = await GameSettingsService.getHapticFeedbackEnabled();
    setState(() {
      _soundEnabled = soundEnabled;
      _hapticEnabled = hapticEnabled;
      _isLoading = false;
    });
  }

  void _navigateToProfile() {
    String orgUnitId = Provider.of<UserState>(context, listen: false).orgUnitId;
    Provider.of<GameScoreState>(
      context,
      listen: false,
    ).resetGameScoreState(orgUnitId: orgUnitId);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const UserProfile(),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
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

  void _navigateToPrivacyPolicy() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const PrivacyPolicy(),
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
              const SettingsHeader(
                title: '⚙️ Settings',
                subtitle: 'Customize your game experience',
              ),

              // Game Settings
              MaterialCard(
                elevation: 2.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: SettingsSection(
                    title: 'Game Settings',
                    icon: IconReference.gamePad,
                    isLoading: _isLoading,
                    children: [
                      SettingToggleItem(
                        title: 'Sound Effects',
                        subtitle: 'Enable background music and sound effects',
                        value: _soundEnabled,
                        onChanged: (value) async {
                          await GameSettingsService.setSoundEffectsEnabled(value);
                          setState(() {
                            _soundEnabled = value;
                          });
                          
                          // Immediately apply sound settings
                          final soundManager = GameSoundService.instance;
                          if (value) {
                            await soundManager.playBackgroundMusic();
                          } else {
                            await soundManager.stopBackgroundMusic();
                          }
                        },
                      ),
                      SettingToggleItem(
                        title: 'Haptic Feedback',
                        subtitle: 'Enable vibration for game actions',
                        value: _hapticEnabled,
                        onChanged: (value) async {
                          await GameSettingsService.setHapticFeedbackEnabled(value);
                          setState(() {
                            _hapticEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0),

              // Account Settings
              Consumer<UserState>(
                builder: (context, userState, child) {
                  bool isUserLoggedIn = userState.isUserLoggedIn;
                  return isUserLoggedIn
                      ? Column(
                          children: [
                            MaterialCard(
                              elevation: 2.0,
                              body: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16.0),
                                child: SettingsSection(
                                  title: 'Account',
                                  icon: IconReference.person,
                                  children: [
                                    SettingNavigationItem(
                                      title: 'Profile',
                                      icon: '👤',
                                      onTap: _navigateToProfile,
                                    ),
                                    const Divider(height: 20),
                                    SettingNavigationItem(
                                      title: 'Change Password',
                                      icon: '🔐',
                                      onTap: _navigateToChangePassword,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                          ],
                        )
                      : const SizedBox.shrink();
                },
              ),

              // Information
              MaterialCard(
                elevation: 2.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: SettingsSection(
                    title: 'Information',
                    icon: 'ℹ️',
                    children: [
                      SettingNavigationItem(
                        title: 'About ${AppInfoReference.appName}',
                        icon: '📱',
                        onTap: _navigateToAbout,
                      ),
                      const Divider(height: 20),
                      SettingNavigationItem(
                        title: 'Privacy Policy',
                        icon: '🔒',
                        onTap: _navigateToPrivacyPolicy,
                      ),
                      const Divider(height: 20),
                      SettingNavigationItem(
                        title: 'Contact Us',
                        icon: '📧',
                        onTap: _navigateToContactUs,
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
