import 'package:go_router/go_router.dart';
import 'package:snake_app/app/routes.dart';
import 'package:snake_app/modules/about/about_page.dart';
import 'package:snake_app/modules/challenges/challenges_page.dart';
import 'package:snake_app/modules/game/game_page.dart';
import 'package:snake_app/modules/home/home_page.dart';
import 'package:snake_app/modules/levels/levels_page.dart';
import 'package:snake_app/modules/onboarding/onboarding_page.dart';
import 'package:snake_app/modules/profile/profile_page.dart';
import 'package:snake_app/modules/scores/scores_page.dart';
import 'package:snake_app/modules/settings/settings_page.dart';
import 'package:snake_app/modules/splash/splash_page.dart';

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
      path: AppRoutes.challenges,
      builder: (context, state) => const ChallengesPage(),
    ),
    GoRoute(
      path: '/challenge/:id',
      builder: (context, state) {
        final challengeId = state.pathParameters['id'] ?? 'sprint-60';
        return GamePage(challengeId: challengeId);
      },
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
