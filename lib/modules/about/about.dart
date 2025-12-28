import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/modules/about/components/about_icon.dart';

class About extends StatelessWidget {
  const About({super.key});

  Widget _buildInfoCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String value,
  }) {
    return MaterialCard(
      elevation: 2.0,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppInfoReference.defaultAppColor,
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
              // App Icon and Title
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    AboutIcon(size: size),
                    Text(
                      AppInfoReference.appName,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Classic Arcade Snake Game',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),

              // App Information Cards
              const SizedBox(height: 20.0),
              _buildInfoCard(
                context,
                icon: '📱',
                title: 'App Name',
                value: AppInfoReference.appName,
              ),
              const SizedBox(height: 12.0),
              _buildInfoCard(
                context,
                icon: '📦',
                title: 'Version',
                value: AppInfoReference.currentAppVersion,
              ),
              const SizedBox(height: 12.0),
              _buildInfoCard(
                context,
                icon: '🆔',
                title: 'Package ID',
                value: AppInfoReference.androidId,
              ),

              // Description Section
              const SizedBox(height: 30.0),
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
                          const Text('ℹ️', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 10.0),
                          Text(
                            'About the Game',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        'A modern take on the classic Snake game with competitive leaderboards, '
                        'smooth controls, and exciting power-ups. Challenge yourself and compete '
                        'with players worldwide!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 15.0),
                      const Row(
                        children: [
                          Text('⚡', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8.0),
                          Text('Fast-paced gameplay'),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      const Row(
                        children: [
                          Text('🏆', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8.0),
                          Text('Global leaderboards'),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      const Row(
                        children: [
                          Text('🎮', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8.0),
                          Text('Intuitive controls'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
