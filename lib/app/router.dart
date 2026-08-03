import 'package:go_router/go_router.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/features/about/about_page.dart';
import 'package:snake_app/features/game/game_page.dart';
import 'package:snake_app/features/home/home_page.dart';
import 'package:snake_app/features/levels/levels_page.dart';
import 'package:snake_app/features/onboarding/onboarding_page.dart';
import 'package:snake_app/features/profile/profile_page.dart';
import 'package:snake_app/features/scores/scores_page.dart';
import 'package:snake_app/features/settings/settings_page.dart';
import 'package:snake_app/features/splash/splash_page.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.levels,
      builder: (context, state) => const LevelsPage(),
    ),
    GoRoute(
      path: '/play/:level',
      builder: (context, state) {
        final levelIndex =
            int.tryParse(state.pathParameters['level'] ?? '1') ?? 1;
        return GamePage(level: levelIndex);
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: AppRoutes.scores,
      builder: (context, state) => const ScoresPage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.about,
      builder: (context, state) => const AboutPage(),
    ),
  ],
);
