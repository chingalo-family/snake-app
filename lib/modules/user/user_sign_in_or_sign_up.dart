import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/modules/user/components/sign_in_or_sign_up_container.dart';

class UserSignInOrSignUp extends StatelessWidget {
  const UserSignInOrSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarContainer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              MaterialCard(
                elevation: 2.0,
                borderRadius: 16.0,
                body: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.shortestSide * 0.20,
                        width: size.shortestSide * 0.20,
                        child: const Image(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/img/app-icon.png'),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Text(
                        'Welcome to ${AppInfoReference.appName}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Sign in to play and compete on the leaderboard!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // Benefits Section
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: MaterialCard(
                      elevation: 1.0,
                      body: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 8.0),
                            Text(
                              'Compete',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Global ranks',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: MaterialCard(
                      elevation: 1.0,
                      body: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Text('📊', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 8.0),
                            Text(
                              'Track Progress',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'View your stats',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: MaterialCard(
                      elevation: 1.0,
                      body: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            const Text('💾', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 8.0),
                            Text(
                              'Save Scores',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Never lose data',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Sign In/Sign Up Form
              const SizedBox(height: 20.0),
              MaterialCard(
                elevation: 3.0,
                borderRadius: 16.0,
                body: Container(
                  width: double.infinity,
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
