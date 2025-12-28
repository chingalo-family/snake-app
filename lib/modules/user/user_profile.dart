import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/user_state/user_entry_form_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/core/models/user.dart';
import 'package:snake_app/core/services/user_service.dart';
import 'package:snake_app/core/utils/app_util.dart';
import 'package:snake_app/modules/user/components/user_game_stats.dart';
import 'package:snake_app/modules/user/user_sign_in_or_sign_up.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  Widget _buildProfileHeader(BuildContext context, User currentUser) {
    return MaterialCard(
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
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3),
                  width: 4,
                ),
              ),
              child: Center(
                child: Text(
                  currentUser.fullName.isNotEmpty
                      ? currentUser.fullName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            // User Name
            Text(
              currentUser.fullName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5.0),
            // Username
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  IconReference.person,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 5.0),
                Text(
                  '@${currentUser.username}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    color: AppInfoReference.defaultAppColor,
                    size: 18,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    'Active Player',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    return MaterialCard(
      elevation: 2.0,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                  size: 48.0,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Confirm Logout',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'Are you sure you want to sign out of your account?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          await _handleLogout(context);
                        },
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await UserService().logout();
      Provider.of<UserState>(context, listen: false).setCurrentUser(User());
      Provider.of<UserEntryFormState>(context, listen: false).resetFormState();
      
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => UserSignInOrSignUp(),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        AppUtil.showToastMessage(message: 'Logged out successfully');
      }
    } catch (error) {
      AppUtil.showToastMessage(message: 'Failed to logout: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      body: Consumer<UserState>(
        builder: (context, userState, child) {
          User currentUser = userState.currentUser;
          return Consumer<GameScoreState>(
            builder: (context, gameScoreState, child) {
              bool isLoading = gameScoreState.isLoading;
              return isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // Profile Header
                            _buildProfileHeader(context, currentUser),
                            const SizedBox(height: 20.0),

                            // Quick Stats Row
                            Row(
                              children: [
                                Expanded(
                                  child: _buildQuickStats(
                                    context,
                                    icon: '🎮',
                                    label: 'Games',
                                    value: gameScoreState.gamesPlayed,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: _buildQuickStats(
                                    context,
                                    icon: IconReference.trophy,
                                    label: 'Best Rank',
                                    value: '#${gameScoreState.bestRank}',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),

                            // Detailed Statistics
                            UserGameStats(
                              gamesPlayed: gameScoreState.gamesPlayed,
                              bestScore: gameScoreState.bestScore,
                              averageScore: gameScoreState.averageScore,
                              bestRank: gameScoreState.bestRank,
                            ),

                            // Achievement Section (placeholder for future)
                            const SizedBox(height: 20.0),
                            MaterialCard(
                              elevation: 2.0,
                              body: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('🌟', style: TextStyle(fontSize: 24)),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          'Achievements',
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15.0),
                                    Center(
                                      child: Text(
                                        'Play more games to unlock achievements!',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            // Logout Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _showLogoutConfirmation(context),
                                icon: const Icon(Icons.logout),
                                label: const Text('Logout'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  foregroundColor: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}
