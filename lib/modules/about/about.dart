import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/modules/about/components/about_icon.dart';

class About extends StatelessWidget {
  const About({super.key});

  Widget _buildFeatureCard(
    BuildContext context, {
    required String emoji,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Hero Section with App Icon
              MaterialCard(
                elevation: 3.0,
                borderRadius: 20.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      // App Icon with Shadow
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: AboutIcon(size: size),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        AppInfoReference.appName,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          'Classic Arcade Snake Game',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // App Info Badges
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoBadge(
                      context,
                      label: 'VERSION',
                      value: AppInfoReference.currentAppVersion,
                      icon: Icons.info_outline,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildInfoBadge(
                      context,
                      label: 'PLATFORM',
                      value: 'Android',
                      icon: Icons.android,
                    ),
                  ),
                ],
              ),

              // Package ID
              const SizedBox(height: 12.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.fingerprint, size: 18),
                        const SizedBox(width: 6.0),
                        Text(
                          'PACKAGE ID',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      AppInfoReference.androidId,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // About the Game Section
              const SizedBox(height: 32.0),
              MaterialCard(
                elevation: 2.0,
                borderRadius: 16.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Icon(
                              Icons.games_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            'About the Game',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'A modern take on the classic Snake game with competitive leaderboards, '
                        'smooth controls, and exciting power-ups. Challenge yourself and compete '
                        'with players worldwide!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Features Grid
              const SizedBox(height: 20.0),
              _buildFeatureCard(
                context,
                emoji: '⚡',
                title: 'Fast-paced Gameplay',
                description:
                    'Experience smooth and responsive controls for the ultimate snake game',
              ),
              const SizedBox(height: 12.0),
              _buildFeatureCard(
                context,
                emoji: '🏆',
                title: 'Global Leaderboards',
                description:
                    'Compete with players worldwide and climb to the top',
              ),
              const SizedBox(height: 12.0),
              _buildFeatureCard(
                context,
                emoji: '🎮',
                title: 'Intuitive Controls',
                description:
                    'Simple swipe controls make it easy to pick up and play',
              ),
              const SizedBox(height: 12.0),
              _buildFeatureCard(
                context,
                emoji: '💎',
                title: 'Power-ups & Combos',
                description:
                    'Collect power-ups and build combos for massive score multipliers',
              ),
              const SizedBox(height: 12.0),
              _buildFeatureCard(
                context,
                emoji: '📊',
                title: 'Statistics Tracking',
                description:
                    'Track your progress with detailed statistics and achievements',
              ),

              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
