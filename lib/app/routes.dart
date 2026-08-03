/// Canonical path constants for [GoRouter] navigation.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const levels = '/levels';
  static const profile = '/profile';
  static const scores = '/scores';
  static const settings = '/settings';
  static const about = '/about';

  static String play(int level) => '/play/$level';
}
