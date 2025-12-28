import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/modules/user/components/sign_in_or_sign_up_container.dart';

class UserSignInOrSignUp extends StatelessWidget {
  const UserSignInOrSignUp({super.key});

  Widget _buildBenefitCard(
    BuildContext context, {
    required String emoji,
    required String title,
    required String subtitle,
    required Color accentColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accentColor.withValues(alpha: 0.15),
              accentColor.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 10.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
            ),
            const SizedBox(height: 4.0),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Scaffold(
      appBar: AppBarContainer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Header Section
              MaterialCard(
                elevation: 4.0,
                borderRadius: 20.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withValues(alpha: 0.25),
                        primaryColor.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      // App Icon with Glow Effect
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: SizedBox(
                            height: size.shortestSide * 0.22,
                            width: size.shortestSide * 0.22,
                            child: const Image(
                              fit: BoxFit.contain,
                              image: AssetImage('assets/img/app-icon.png'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Welcome to ${AppInfoReference.appName}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          'Sign in to unlock the full experience!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Benefits Section
              const SizedBox(height: 24.0),
              Row(
                children: [
                  _buildBenefitCard(
                    context,
                    emoji: '🏆',
                    title: 'Compete',
                    subtitle: 'Global ranks',
                    accentColor: const Color(0xFFFFB300), // Amber
                  ),
                  const SizedBox(width: 12.0),
                  _buildBenefitCard(
                    context,
                    emoji: '📊',
                    title: 'Track',
                    subtitle: 'Your progress',
                    accentColor: const Color(0xFF00ACC1), // Cyan
                  ),
                  const SizedBox(width: 12.0),
                  _buildBenefitCard(
                    context,
                    emoji: '💾',
                    title: 'Save',
                    subtitle: 'All scores',
                    accentColor: const Color(0xFF7B1FA2), // Purple
                  ),
                ],
              ),

              // Sign In/Sign Up Form
              const SizedBox(height: 24.0),
              MaterialCard(
                elevation: 3.0,
                borderRadius: 16.0,
                body: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: const SignInOrSignUpContainer(),
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

      ),
    );
  }
}
