// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Snake App';

  @override
  String get tagline => 'Grow, collect, climb levels';

  @override
  String get play => 'Play';

  @override
  String get levels => 'Levels';

  @override
  String get scores => 'Scores';

  @override
  String get highScores => 'High Scores';

  @override
  String get profile => 'Profile';

  @override
  String get createProfile => 'Create profile';

  @override
  String get settings => 'Settings';

  @override
  String get about => 'About';

  @override
  String get home => 'Home';

  @override
  String get more => 'More';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get scoreboard => 'Scoreboard';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get getStarted => 'Get Started';

  @override
  String pageOf(int current, int total) {
    return '$current/$total';
  }

  @override
  String get start => 'Start';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving…';

  @override
  String get resume => 'Resume';

  @override
  String get restart => 'Restart';

  @override
  String get quitToLevels => 'Quit to Levels';

  @override
  String get playAgain => 'Play again';

  @override
  String get backToLevels => 'Back to Levels';

  @override
  String get playAnyway => 'Play anyway';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'Paused';

  @override
  String get gameOver => 'Game over';

  @override
  String get score => 'Score';

  @override
  String get level => 'Level';

  @override
  String get combo => 'Combo';

  @override
  String get stats => 'Stats';

  @override
  String get eaten => 'Eaten';

  @override
  String get last => 'Last';

  @override
  String get version => 'Version';

  @override
  String get build => 'Build';

  @override
  String get package => 'Package';

  @override
  String get madeBy => 'Made by';

  @override
  String get highlights => 'Highlights';

  @override
  String get audio => 'Audio';

  @override
  String get feel => 'Feel';

  @override
  String get display => 'Display';

  @override
  String get appSection => 'App';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get swahili => 'Kiswahili';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get soundEffects => 'Sound effects';

  @override
  String get soundEffectsSubtitle => 'Eat, collide, and UI taps';

  @override
  String get backgroundMusic => 'Background music';

  @override
  String get backgroundMusicSubtitle => 'Independent of sound effects';

  @override
  String get hapticFeedback => 'Haptic feedback';

  @override
  String get hapticFeedbackSubtitle => 'Mobile only';

  @override
  String get showControlHints => 'Show control hints';

  @override
  String get showControlHintsSubtitle => 'On-board swipe and keyboard tips';

  @override
  String get selectLanguage => 'Select language';

  @override
  String appDisplayLanguage(String language) {
    return 'App language: $language';
  }

  @override
  String get aboutSubtitle => 'Version, credits, and highlights';

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get checkForUpdatesSubtitle => 'Opens Google Play or the App Store';

  @override
  String get checkForUpdatesSubtitleAndroid => 'Opens Google Play';

  @override
  String get checkForUpdatesSubtitleIos => 'Opens the App Store';

  @override
  String get checkedUpdates => 'Checked updates';

  @override
  String get usernameRequired => 'Username';

  @override
  String get fullNameRequired => 'Name';

  @override
  String get emailOptional => 'Email';

  @override
  String get phoneOptional => 'Phone';

  @override
  String get usernameHint => 'Choose a player name';

  @override
  String get fullNameHint => 'Your name';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get phoneHint => 'e.g. +255712345678';

  @override
  String get usernameRequiredError => 'Username is required';

  @override
  String get usernameTooShort => 'At least 2 characters';

  @override
  String get usernameTooLong => 'At most 24 characters';

  @override
  String get usernameInvalid => 'Use letters, numbers, and underscores only';

  @override
  String get fullNameRequiredError => 'Name is required';

  @override
  String get fullNameTooShort => 'At least 2 characters';

  @override
  String get fullNameTooLong => 'At most 60 characters';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get phoneInvalid => 'Enter a valid phone number (7–15 digits)';

  @override
  String get profileSaved => 'Profile saved locally';

  @override
  String get profileSavedWithScore => 'Profile saved — your score was kept';

  @override
  String get selectAvatar => 'Choose avatar';

  @override
  String get profileHelp =>
      'A profile is only required to save high scores and level progress. You can play without one.';

  @override
  String get best => 'Best';

  @override
  String get games => 'Games';

  @override
  String get overallBest => 'Overall best';

  @override
  String get perLevel => 'Per level';

  @override
  String get noScoresYet => 'No scores yet - finish a run to set a best.';

  @override
  String get createProfileForScores =>
      'Create a profile to keep offline high scores.';

  @override
  String get newPersonalBest => 'New personal best!';

  @override
  String get saveScoreCreateProfile => 'Save score - create profile';

  @override
  String get onboardingWelcomeTitle => 'Welcome';

  @override
  String get onboardingWelcomeBody =>
      'Grow, collect, climb levels - a premium snake experience for every screen.';

  @override
  String get onboardingMoveTitle => 'How to move';

  @override
  String get onboardingMoveTouch =>
      'Swipe up, down, left, or right to steer. Avoid walls and your own tail.';

  @override
  String get onboardingMoveDesktop =>
      'Use arrow keys (or WASD) to steer. Esc pauses.';

  @override
  String get onboardingCollectTitle => 'Collect & score';

  @override
  String get onboardingCollectBody =>
      'Animals and treats have different point values. Chain eats for combo bonuses.';

  @override
  String get onboardingProfileTitle => 'Levels & profile';

  @override
  String get onboardingProfileBody =>
      'Unlock levels as you improve. Create a local profile to keep high scores offline.';

  @override
  String get hintSwipe => 'Swipe to move';

  @override
  String get hintKeyboard => 'Arrows / WASD to move · Esc pause';

  @override
  String get playFreelyHint => '· Play freely - profile saves bests';

  @override
  String get aboutDescription =>
      'An engaging, offline-first snake game with responsive play, tiered collectibles, levels, and local high scores.';

  @override
  String get highlightSwipe => '• Swipe on touch, arrows on desktop';

  @override
  String get highlightOrientation => '• Portrait and landscape playground';

  @override
  String get highlightAudio => '• Separate SFX and music toggles';

  @override
  String get highlightProfile => '• Profile-gated offline bests';

  @override
  String get densityDense => 'Dense';

  @override
  String get densityStandard => 'Standard';

  @override
  String get densitySpacious => 'Spacious';

  @override
  String get speedVeryFast => 'Very fast';

  @override
  String get speedFast => 'Fast';

  @override
  String get speedMedium => 'Medium';

  @override
  String get speedSlow => 'Slow';

  @override
  String levelUnlocked(int level) {
    return 'Level $level unlocked';
  }

  @override
  String levelNumber(int level) {
    return 'Level $level';
  }

  @override
  String levelUnlockHint(int score, int level) {
    return 'Score $score+ on level $level';
  }

  @override
  String scoreLevelSummary(int score, int level) {
    return 'Score $score · Level $level';
  }

  @override
  String bestComboSuffix(int combo) {
    return ' · Best combo x$combo';
  }

  @override
  String levelUnlockedBanner(int level) {
    return 'Level $level unlocked!';
  }

  @override
  String highestLevelCombo(int level, int combo) {
    return 'Highest level $level · Best combo x$combo';
  }

  @override
  String scoreLabelValue(int score) {
    return 'Score $score';
  }

  @override
  String levelLabelValue(int level) {
    return 'Level $level';
  }

  @override
  String eatenLabelValue(int count) {
    return 'Eaten $count';
  }

  @override
  String lastLabelValue(String icon) {
    return 'Last $icon';
  }

  @override
  String comboValue(int combo) {
    return 'x$combo';
  }

  @override
  String speedDensity(String speed, String density) {
    return '$speed · $density';
  }

  @override
  String updateUpToDate(String version) {
    return 'You’re on version $version.';
  }

  @override
  String updateOpenPlayStore(String version) {
    return 'Opening Google Play for version $version.';
  }

  @override
  String updateOpenAppStore(String version) {
    return 'Opening the App Store for version $version.';
  }

  @override
  String get updateUnsupported =>
      'Store updates are available on Android and iOS only.';

  @override
  String errorWithDetails(String details) {
    return 'Error: $details';
  }

  @override
  String get modeClassic => 'Classic';

  @override
  String get modeWrap => 'Wrap';

  @override
  String get modeMaze => 'Maze';

  @override
  String get modeWrapMaze => 'Wrap maze';

  @override
  String get modeClassicTip => 'Walls end the run.';

  @override
  String get modeWrapTip => 'Edges loop.';

  @override
  String get modeMazeTip => 'Rocks end the run.';

  @override
  String get modeWrapMazeTip => 'Edges loop — rocks still end the run.';

  @override
  String get onboardingMoveReverseHint => 'You can’t reverse into yourself.';

  @override
  String get snakeLook => 'Snake look';

  @override
  String get snakeLookSubtitle => 'Cosmetic skins unlock with levels';

  @override
  String get selectSnakeLook => 'Select snake look';

  @override
  String skinLockedHint(int level) {
    return 'Unlock at level $level';
  }

  @override
  String get skinForest => 'Forest';

  @override
  String get skinAmberLeaf => 'Amber leaf';

  @override
  String get skinRiver => 'River';

  @override
  String get skinSunset => 'Sunset';

  @override
  String get skinMidnight => 'Midnight';

  @override
  String get skinChampion => 'Champion';

  @override
  String skinUnlockedBanner(String skin) {
    return 'New look: $skin';
  }

  @override
  String get showDailyTip => 'Tips & quotes';

  @override
  String get showDailyTipSubtitle =>
      'Show a fresh random tip each time you open the app';

  @override
  String get dailyTipTitle => 'A tip for you';

  @override
  String get dailyTipGotIt => 'Got it';

  @override
  String get shareScore => 'Share as image';

  @override
  String get sharePreparing => 'Preparing image…';

  @override
  String get shareFailed => 'Couldn’t share the image right now. Try again.';

  @override
  String get shareSavedToDisk =>
      'Image saved to Downloads/Snake App — open it from there to share.';

  @override
  String get sharePreviewTitle => 'Share post';

  @override
  String get sharePreviewSubtitle =>
      'Preview your image, then share it to social media';

  @override
  String get shareAsImageConfirm => 'Share image';

  @override
  String get shareOverallBest => 'Share overall best as image';

  @override
  String get shareCardPromo => 'Offline fun · grow, collect, climb';

  @override
  String get shareCardDownload => 'Get Snake App on Google Play';

  @override
  String get shareCardAvailableOn => 'Available on';

  @override
  String get shareCardGooglePlay => 'Google Play';

  @override
  String get shareCardAppStore => 'App Store';

  @override
  String get shareCardDownloadBoth =>
      'Download free on Google Play & App Store';

  @override
  String get shareCardAchievements => 'This run';

  @override
  String get shareCardOverallBestLabel => 'My overall best';

  @override
  String shareCardOverallBestSummary(int score, int level) {
    return 'Best $score · Level $level unlocked';
  }

  @override
  String shareTextCaption(int score, int level) {
    return 'I scored $score on Snake App (Level $level)! Available on Google Play & App Store.';
  }

  @override
  String shareTextOverallCaption(int score, int level) {
    return 'My overall best on Snake App is $score (Level $level unlocked)! Available on Google Play & App Store.';
  }

  @override
  String get dailyQuote0 => 'One careful turn beats a fast crash.';

  @override
  String get dailyQuote1 => 'Your best score started as a first try.';

  @override
  String get dailyQuote2 => 'Grow steady. The board will wait.';

  @override
  String get dailyQuote3 =>
      'Collect what you can reach — leave the rest for next run.';

  @override
  String get dailyQuote4 => 'Patience on the edges keeps the combo alive.';

  @override
  String get dailyQuote5 =>
      'A short run with focus beats a long run on autopilot.';

  @override
  String get dailyQuote6 => 'Every unlock began with a single eat.';

  @override
  String get dailyQuote7 => 'Turn early. Celebrate later.';

  @override
  String get dailyQuote8 => 'The board is fair — keep your path clear.';

  @override
  String get dailyQuote9 => 'Slow is smooth. Smooth is fast.';

  @override
  String get dailyQuote10 => 'Chase the rare treat, but respect the walls.';

  @override
  String get dailyQuote11 => 'Today’s high score is tomorrow’s warm-up.';

  @override
  String get dailyQuote12 => 'One more careful bite. That’s enough.';

  @override
  String get dailyQuote13 => 'Length is pride — space is wisdom.';

  @override
  String get dailyQuote14 => 'Breathe. Swipe. Grow.';

  @override
  String get dailyQuote15 => 'Missed a turn? Restart with a smile.';

  @override
  String get dailyQuote16 => 'Combos love calm hands.';

  @override
  String get dailyQuote17 => 'The next level unlocks for the patient.';

  @override
  String get dailyQuote18 => 'Play offline. Progress is yours.';

  @override
  String get dailyQuote19 => 'Corners teach more than open fields.';

  @override
  String get dailyQuote20 =>
      'A green path is a kind path — leave room to turn.';

  @override
  String get dailyQuote21 => 'Epic food is loud. Soft turns win.';

  @override
  String get dailyQuote22 => 'You don’t need perfect — just another try.';

  @override
  String get dailyQuote23 =>
      'Wrap the board in your mind before you wrap the edge.';

  @override
  String get dailyQuote24 => 'Rocks are teachers in disguise.';

  @override
  String get dailyQuote25 => 'Champion looks follow champion habits.';

  @override
  String get dailyQuote26 => 'Share the joy, keep the lessons.';

  @override
  String get dailyQuote27 => 'Small grids, big focus.';

  @override
  String get dailyQuote28 => 'The snake grows; so does your judgment.';

  @override
  String get dailyQuote29 => 'Open again anytime — a new tip is waiting.';
}
