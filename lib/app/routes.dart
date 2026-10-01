
abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const levels = '/levels';
  static const profile = '/profile';
  static const scores = '/scores';
  static const challenges = '/challenges';
  static const settings = '/settings';
  static const about = '/about';

  static String play(int level) => '/play/$level';

  static String challenge(String id) => '/challenge/$id';
}
