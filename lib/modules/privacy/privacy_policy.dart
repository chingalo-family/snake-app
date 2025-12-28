import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String content,
    String? emoji,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (emoji != null) ...[
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8.0),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ),
        ],
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
              // Header
              MaterialCard(
                elevation: 2.0,
                borderRadius: 16.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Icon(
                              Icons.privacy_tip_outlined,
                              size: 28,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Privacy Policy',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  'Last Updated: December 28, 2024',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Introduction
              MaterialCard(
                elevation: 1.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'We are committed to protecting your privacy and ensuring you have a positive experience while using ${AppInfoReference.appName}. This policy explains how we collect, use, and safeguard your information.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // What We Collect
              _buildSection(
                context: context,
                title: 'What We Collect',
                emoji: '📊',
                content: '',
              ),
              _buildBulletPoint(context, 'Account info: Username, name, email, phone (optional)'),
              _buildBulletPoint(context, 'Gameplay: Scores, statistics, rankings, and progress'),
              _buildBulletPoint(context, 'Settings: Sound and haptic feedback preferences'),
              _buildBulletPoint(context, 'Technical: Device info and app version'),

              const SizedBox(height: 16.0),

              // How We Use It
              _buildSection(
                context: context,
                title: 'How We Use Your Information',
                emoji: '🎯',
                content: '',
              ),
              _buildBulletPoint(context, 'Save your game progress and scores'),
              _buildBulletPoint(context, 'Display you on leaderboards'),
              _buildBulletPoint(context, 'Improve app features and fix bugs'),
              _buildBulletPoint(context, 'Send important account notifications'),
              _buildBulletPoint(context, 'Provide customer support'),

              const SizedBox(height: 16.0),

              // What We Share
              _buildSection(
                context: context,
                title: 'What We Share',
                emoji: '🔒',
                content: 'Your username and scores are visible on leaderboards. We use DHIS2 for secure data storage. We NEVER sell your data to anyone.',
              ),

              const SizedBox(height: 16.0),

              // Your Rights
              _buildSection(
                context: context,
                title: 'Your Rights',
                emoji: '✅',
                content: '',
              ),
              _buildBulletPoint(context, 'View and update your profile anytime'),
              _buildBulletPoint(context, 'Change your password in Settings'),
              _buildBulletPoint(context, 'Control sound and haptic feedback'),
              _buildBulletPoint(context, 'Request account deletion'),
              _buildBulletPoint(context, 'Contact us with privacy concerns'),

              const SizedBox(height: 16.0),

              // Security
              _buildSection(
                context: context,
                title: 'Security',
                emoji: '🛡️',
                content: 'All data transmission is encrypted using HTTPS. Passwords are never stored in plain text. Your data is securely stored and regularly backed up.',
              ),

              const SizedBox(height: 16.0),

              // Children's Privacy
              _buildSection(
                context: context,
                title: 'Children\'s Privacy',
                emoji: '👶',
                content: 'This app is not intended for children under 13. If you are a parent and your child has used this app, please contact us immediately.',
              ),

              const SizedBox(height: 16.0),

              // Contact Section
              MaterialCard(
                elevation: 2.0,
                borderRadius: 12.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('📧', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8.0),
                          Text(
                            'Questions About Privacy?',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        'Contact us at: chingalo.family@gmail.com',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Or use the "Contact Us" feature in Settings',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24.0),

              // Footer
              Center(
                child: Column(
                  children: [
                    Text(
                      'Your Privacy Matters',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'We\'re committed to keeping your data safe and secure.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Version 1.0 • Effective: December 28, 2024',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                    ),
                  ],
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
