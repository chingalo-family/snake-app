import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/game_score_state/game_score_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/icon_reference.dart';
import 'package:snake_app/core/models/user.dart';
import 'package:snake_app/modules/user/components/user_game_stats.dart';

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
