import 'package:flutter/material.dart';
import 'package:snake_app/core/bootstrap/desktop_window.dart';

/// Brand tokens — see docs/THEME_AND_COLORS.md
const Color _brandPrimary = Color(0xFF1FA87A);
const Color _brandSecondary = Color(0xFFF0A202);
const Color _surfaceBg = Color(0xFF0B1F1A);
const Color _surfaceRaised = Color(0xFF12352C);
const Color _textPrimary = Color(0xFFF2F7F4);
const Color _textSecondary = Color(0xFFA8C4B8);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDesktopWindow();
  runApp(const SnakeApp());
}

class SnakeApp extends StatelessWidget {
  const SnakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _brandPrimary,
          brightness: Brightness.dark,
          primary: _brandPrimary,
          secondary: _brandSecondary,
          surface: _surfaceRaised,
        ),
        scaffoldBackgroundColor: _surfaceBg,
      ),
      home: const LandingPage(),
    );
  }
}

/// Temporary landing until feature modules from the implementation plan are built.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_surfaceBg, _surfaceRaised, _surfaceBg],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),
                Text(
                  'Snake App',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: _textPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Grow, collect, climb levels — an engaging snake experience for phone, tablet, and desktop.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _textSecondary,
                        height: 1.4,
                      ),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: _brandPrimary,
                    foregroundColor: _surfaceBg,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Play — coming soon'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Review docs/IMPLEMENTATION_PLAN.md before feature build.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _textSecondary,
                      ),
                ),
                const Spacer(flex: 3),
                Text(
                  'chingalo.family.snake_app',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _textSecondary.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
