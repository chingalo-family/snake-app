import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Snake App'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Grow, collect, climb levels'**
  String get tagline;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @levels.
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get levels;

  /// No description provided for @scores.
  ///
  /// In en, this message translates to:
  /// **'Scores'**
  String get scores;

  /// No description provided for @highScores.
  ///
  /// In en, this message translates to:
  /// **'High Scores'**
  String get highScores;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @createProfile.
  ///
  /// In en, this message translates to:
  /// **'Create profile'**
  String get createProfile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @scoreboard.
  ///
  /// In en, this message translates to:
  /// **'Scoreboard'**
  String get scoreboard;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'{current}/{total}'**
  String pageOf(int current, int total);

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @quitToLevels.
  ///
  /// In en, this message translates to:
  /// **'Quit to Levels'**
  String get quitToLevels;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @backToLevels.
  ///
  /// In en, this message translates to:
  /// **'Back to Levels'**
  String get backToLevels;

  /// No description provided for @playAnyway.
  ///
  /// In en, this message translates to:
  /// **'Play anyway'**
  String get playAnyway;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game over'**
  String get gameOver;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @combo.
  ///
  /// In en, this message translates to:
  /// **'Combo'**
  String get combo;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @eaten.
  ///
  /// In en, this message translates to:
  /// **'Eaten'**
  String get eaten;

  /// No description provided for @last.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get last;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @build.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// No description provided for @package.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get package;

  /// No description provided for @madeBy.
  ///
  /// In en, this message translates to:
  /// **'Made by'**
  String get madeBy;

  /// No description provided for @highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get highlights;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @feel.
  ///
  /// In en, this message translates to:
  /// **'Feel'**
  String get feel;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @appSection.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get appSection;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @swahili.
  ///
  /// In en, this message translates to:
  /// **'Kiswahili'**
  String get swahili;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get soundEffects;

  /// No description provided for @soundEffectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Eat, collide, and UI taps'**
  String get soundEffectsSubtitle;

  /// No description provided for @backgroundMusic.
  ///
  /// In en, this message translates to:
  /// **'Background music'**
  String get backgroundMusic;

  /// No description provided for @backgroundMusicSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Independent of sound effects'**
  String get backgroundMusicSubtitle;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get hapticFeedback;

  /// No description provided for @hapticFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile only'**
  String get hapticFeedbackSubtitle;

  /// No description provided for @showControlHints.
  ///
  /// In en, this message translates to:
  /// **'Show control hints'**
  String get showControlHints;

  /// No description provided for @showControlHintsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'On-board swipe and keyboard tips'**
  String get showControlHintsSubtitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @appDisplayLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language: {language}'**
  String appDisplayLanguage(String language);

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version, credits, and highlights'**
  String get aboutSubtitle;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// No description provided for @checkForUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Opens Google Play or the App Store'**
  String get checkForUpdatesSubtitle;

  /// No description provided for @checkForUpdatesSubtitleAndroid.
  ///
  /// In en, this message translates to:
  /// **'Opens Google Play'**
  String get checkForUpdatesSubtitleAndroid;

  /// No description provided for @checkForUpdatesSubtitleIos.
  ///
  /// In en, this message translates to:
  /// **'Opens the App Store'**
  String get checkForUpdatesSubtitleIos;

  /// No description provided for @checkedUpdates.
  ///
  /// In en, this message translates to:
  /// **'Checked updates'**
  String get checkedUpdates;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameRequired;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fullNameRequired;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailOptional;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneOptional;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a player name'**
  String get usernameHint;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get fullNameHint;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get emailHint;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. +255712345678'**
  String get phoneHint;

  /// No description provided for @usernameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequiredError;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 2 characters'**
  String get usernameTooShort;

  /// No description provided for @usernameTooLong.
  ///
  /// In en, this message translates to:
  /// **'At most 24 characters'**
  String get usernameTooLong;

  /// No description provided for @usernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use letters, numbers, and underscores only'**
  String get usernameInvalid;

  /// No description provided for @fullNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get fullNameRequiredError;

  /// No description provided for @fullNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'At least 2 characters'**
  String get fullNameTooShort;

  /// No description provided for @fullNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'At most 60 characters'**
  String get fullNameTooLong;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number (7–15 digits)'**
  String get phoneInvalid;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved locally'**
  String get profileSaved;

  /// No description provided for @profileSavedWithScore.
  ///
  /// In en, this message translates to:
  /// **'Profile saved — your score was kept'**
  String get profileSavedWithScore;

  /// No description provided for @selectAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose avatar'**
  String get selectAvatar;

  /// No description provided for @profileHelp.
  ///
  /// In en, this message translates to:
  /// **'A profile is only required to save high scores and level progress. You can play without one.'**
  String get profileHelp;

  /// No description provided for @best.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get best;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @overallBest.
  ///
  /// In en, this message translates to:
  /// **'Overall best'**
  String get overallBest;

  /// No description provided for @perLevel.
  ///
  /// In en, this message translates to:
  /// **'Per level'**
  String get perLevel;

  /// No description provided for @noScoresYet.
  ///
  /// In en, this message translates to:
  /// **'No scores yet - finish a run to set a best.'**
  String get noScoresYet;

  /// No description provided for @createProfileForScores.
  ///
  /// In en, this message translates to:
  /// **'Create a profile to keep offline high scores.'**
  String get createProfileForScores;

  /// No description provided for @newPersonalBest.
  ///
  /// In en, this message translates to:
  /// **'New personal best!'**
  String get newPersonalBest;

  /// No description provided for @saveScoreCreateProfile.
  ///
  /// In en, this message translates to:
  /// **'Save score - create profile'**
  String get saveScoreCreateProfile;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Grow, collect, climb levels - a premium snake experience for every screen.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingMoveTitle.
  ///
  /// In en, this message translates to:
  /// **'How to move'**
  String get onboardingMoveTitle;

  /// No description provided for @onboardingMoveTouch.
  ///
  /// In en, this message translates to:
  /// **'Swipe up, down, left, or right to steer. Avoid walls and your own tail.'**
  String get onboardingMoveTouch;

  /// No description provided for @onboardingMoveDesktop.
  ///
  /// In en, this message translates to:
  /// **'Use arrow keys (or WASD) to steer. Esc pauses.'**
  String get onboardingMoveDesktop;

  /// No description provided for @onboardingCollectTitle.
  ///
  /// In en, this message translates to:
  /// **'Collect & score'**
  String get onboardingCollectTitle;

  /// No description provided for @onboardingCollectBody.
  ///
  /// In en, this message translates to:
  /// **'Animals and treats have different point values. Chain eats for combo bonuses.'**
  String get onboardingCollectBody;

  /// No description provided for @onboardingProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Levels & profile'**
  String get onboardingProfileTitle;

  /// No description provided for @onboardingProfileBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock levels as you improve. Create a local profile to keep high scores offline.'**
  String get onboardingProfileBody;

  /// No description provided for @hintSwipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe to move'**
  String get hintSwipe;

  /// No description provided for @hintKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Arrows / WASD to move · Esc pause'**
  String get hintKeyboard;

  /// No description provided for @playFreelyHint.
  ///
  /// In en, this message translates to:
  /// **'· Play freely - profile saves bests'**
  String get playFreelyHint;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'An engaging, offline-first snake game with responsive play, tiered collectibles, levels, and local high scores.'**
  String get aboutDescription;

  /// No description provided for @highlightSwipe.
  ///
  /// In en, this message translates to:
  /// **'• Swipe on touch, arrows on desktop'**
  String get highlightSwipe;

  /// No description provided for @highlightOrientation.
  ///
  /// In en, this message translates to:
  /// **'• Portrait and landscape playground'**
  String get highlightOrientation;

  /// No description provided for @highlightAudio.
  ///
  /// In en, this message translates to:
  /// **'• Separate SFX and music toggles'**
  String get highlightAudio;

  /// No description provided for @highlightProfile.
  ///
  /// In en, this message translates to:
  /// **'• Profile-gated offline bests'**
  String get highlightProfile;

  /// No description provided for @densityDense.
  ///
  /// In en, this message translates to:
  /// **'Dense'**
  String get densityDense;

  /// No description provided for @densityStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get densityStandard;

  /// No description provided for @densitySpacious.
  ///
  /// In en, this message translates to:
  /// **'Spacious'**
  String get densitySpacious;

  /// No description provided for @speedVeryFast.
  ///
  /// In en, this message translates to:
  /// **'Very fast'**
  String get speedVeryFast;

  /// No description provided for @speedFast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get speedFast;

  /// No description provided for @speedMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get speedMedium;

  /// No description provided for @speedSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get speedSlow;

  /// No description provided for @levelUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Level {level} unlocked'**
  String levelUnlocked(int level);

  /// No description provided for @levelNumber.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelNumber(int level);

  /// No description provided for @levelUnlockHint.
  ///
  /// In en, this message translates to:
  /// **'Score {score}+ on level {level}'**
  String levelUnlockHint(int score, int level);

  /// No description provided for @scoreLevelSummary.
  ///
  /// In en, this message translates to:
  /// **'Score {score} · Level {level}'**
  String scoreLevelSummary(int score, int level);

  /// No description provided for @bestComboSuffix.
  ///
  /// In en, this message translates to:
  /// **' · Best combo x{combo}'**
  String bestComboSuffix(int combo);

  /// No description provided for @levelUnlockedBanner.
  ///
  /// In en, this message translates to:
  /// **'Level {level} unlocked!'**
  String levelUnlockedBanner(int level);

  /// No description provided for @highestLevelCombo.
  ///
  /// In en, this message translates to:
  /// **'Highest level {level} · Best combo x{combo}'**
  String highestLevelCombo(int level, int combo);

  /// No description provided for @scoreLabelValue.
  ///
  /// In en, this message translates to:
  /// **'Score {score}'**
  String scoreLabelValue(int score);

  /// No description provided for @levelLabelValue.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelLabelValue(int level);

  /// No description provided for @eatenLabelValue.
  ///
  /// In en, this message translates to:
  /// **'Eaten {count}'**
  String eatenLabelValue(int count);

  /// No description provided for @lastLabelValue.
  ///
  /// In en, this message translates to:
  /// **'Last {icon}'**
  String lastLabelValue(String icon);

  /// No description provided for @comboValue.
  ///
  /// In en, this message translates to:
  /// **'x{combo}'**
  String comboValue(int combo);

  /// No description provided for @speedDensity.
  ///
  /// In en, this message translates to:
  /// **'{speed} · {density}'**
  String speedDensity(String speed, String density);

  /// No description provided for @updateUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You’re on version {version}.'**
  String updateUpToDate(String version);

  /// No description provided for @updateOpenPlayStore.
  ///
  /// In en, this message translates to:
  /// **'Opening Google Play for version {version}.'**
  String updateOpenPlayStore(String version);

  /// No description provided for @updateOpenAppStore.
  ///
  /// In en, this message translates to:
  /// **'Opening the App Store for version {version}.'**
  String updateOpenAppStore(String version);

  /// No description provided for @updateUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Store updates are available on Android and iOS only.'**
  String get updateUnsupported;

  /// No description provided for @errorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {details}'**
  String errorWithDetails(String details);

  /// No description provided for @modeClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get modeClassic;

  /// No description provided for @modeWrap.
  ///
  /// In en, this message translates to:
  /// **'Wrap'**
  String get modeWrap;

  /// No description provided for @modeMaze.
  ///
  /// In en, this message translates to:
  /// **'Maze'**
  String get modeMaze;

  /// No description provided for @modeWrapMaze.
  ///
  /// In en, this message translates to:
  /// **'Wrap maze'**
  String get modeWrapMaze;

  /// No description provided for @modeClassicTip.
  ///
  /// In en, this message translates to:
  /// **'Walls end the run.'**
  String get modeClassicTip;

  /// No description provided for @modeWrapTip.
  ///
  /// In en, this message translates to:
  /// **'Edges loop.'**
  String get modeWrapTip;

  /// No description provided for @modeMazeTip.
  ///
  /// In en, this message translates to:
  /// **'Rocks end the run.'**
  String get modeMazeTip;

  /// No description provided for @modeWrapMazeTip.
  ///
  /// In en, this message translates to:
  /// **'Edges loop — rocks still end the run.'**
  String get modeWrapMazeTip;

  /// No description provided for @onboardingMoveReverseHint.
  ///
  /// In en, this message translates to:
  /// **'You can’t reverse into yourself.'**
  String get onboardingMoveReverseHint;

  /// No description provided for @snakeLook.
  ///
  /// In en, this message translates to:
  /// **'Snake look'**
  String get snakeLook;

  /// No description provided for @snakeLookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cosmetic skins unlock with levels'**
  String get snakeLookSubtitle;

  /// No description provided for @selectSnakeLook.
  ///
  /// In en, this message translates to:
  /// **'Select snake look'**
  String get selectSnakeLook;

  /// No description provided for @skinLockedHint.
  ///
  /// In en, this message translates to:
  /// **'Unlock at level {level}'**
  String skinLockedHint(int level);

  /// No description provided for @skinForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get skinForest;

  /// No description provided for @skinAmberLeaf.
  ///
  /// In en, this message translates to:
  /// **'Amber leaf'**
  String get skinAmberLeaf;

  /// No description provided for @skinRiver.
  ///
  /// In en, this message translates to:
  /// **'River'**
  String get skinRiver;

  /// No description provided for @skinSunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get skinSunset;

  /// No description provided for @skinMidnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get skinMidnight;

  /// No description provided for @skinChampion.
  ///
  /// In en, this message translates to:
  /// **'Champion'**
  String get skinChampion;

  /// No description provided for @skinUnlockedBanner.
  ///
  /// In en, this message translates to:
  /// **'New look: {skin}'**
  String skinUnlockedBanner(String skin);

  /// No description provided for @showDailyTip.
  ///
  /// In en, this message translates to:
  /// **'Tips & quotes'**
  String get showDailyTip;

  /// No description provided for @showDailyTipSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show a fresh random tip each time you open the app'**
  String get showDailyTipSubtitle;

  /// No description provided for @dailyTipTitle.
  ///
  /// In en, this message translates to:
  /// **'A tip for you'**
  String get dailyTipTitle;

  /// No description provided for @dailyTipGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get dailyTipGotIt;

  /// No description provided for @shareScore.
  ///
  /// In en, this message translates to:
  /// **'Share as image'**
  String get shareScore;

  /// No description provided for @sharePreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing image…'**
  String get sharePreparing;

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t share the image right now. Try again.'**
  String get shareFailed;

  /// No description provided for @shareSavedToDisk.
  ///
  /// In en, this message translates to:
  /// **'Image saved to Downloads/Snake App — open it from there to share.'**
  String get shareSavedToDisk;

  /// No description provided for @sharePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Share post'**
  String get sharePreviewTitle;

  /// No description provided for @sharePreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preview your image, then share it to social media'**
  String get sharePreviewSubtitle;

  /// No description provided for @shareAsImageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Share image'**
  String get shareAsImageConfirm;

  /// No description provided for @shareOverallBest.
  ///
  /// In en, this message translates to:
  /// **'Share overall best as image'**
  String get shareOverallBest;

  /// No description provided for @shareCardPromo.
  ///
  /// In en, this message translates to:
  /// **'Offline fun · grow, collect, climb'**
  String get shareCardPromo;

  /// No description provided for @shareCardDownload.
  ///
  /// In en, this message translates to:
  /// **'Get Snake App on Google Play'**
  String get shareCardDownload;

  /// No description provided for @shareCardAvailableOn.
  ///
  /// In en, this message translates to:
  /// **'Available on'**
  String get shareCardAvailableOn;

  /// No description provided for @shareCardGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Google Play'**
  String get shareCardGooglePlay;

  /// No description provided for @shareCardAppStore.
  ///
  /// In en, this message translates to:
  /// **'App Store'**
  String get shareCardAppStore;

  /// No description provided for @shareCardDownloadBoth.
  ///
  /// In en, this message translates to:
  /// **'Download free on Google Play & App Store'**
  String get shareCardDownloadBoth;

  /// No description provided for @shareCardAchievements.
  ///
  /// In en, this message translates to:
  /// **'This run'**
  String get shareCardAchievements;

  /// No description provided for @shareCardOverallBestLabel.
  ///
  /// In en, this message translates to:
  /// **'My overall best'**
  String get shareCardOverallBestLabel;

  /// No description provided for @shareCardOverallBestSummary.
  ///
  /// In en, this message translates to:
  /// **'Best {score} · Level {level} unlocked'**
  String shareCardOverallBestSummary(int score, int level);

  /// No description provided for @shareTextCaption.
  ///
  /// In en, this message translates to:
  /// **'I scored {score} on Snake App (Level {level})! Available on Google Play & App Store.'**
  String shareTextCaption(int score, int level);

  /// No description provided for @shareTextOverallCaption.
  ///
  /// In en, this message translates to:
  /// **'My overall best on Snake App is {score} (Level {level} unlocked)! Available on Google Play & App Store.'**
  String shareTextOverallCaption(int score, int level);

  /// No description provided for @dailyQuote0.
  ///
  /// In en, this message translates to:
  /// **'One careful turn beats a fast crash.'**
  String get dailyQuote0;

  /// No description provided for @dailyQuote1.
  ///
  /// In en, this message translates to:
  /// **'Your best score started as a first try.'**
  String get dailyQuote1;

  /// No description provided for @dailyQuote2.
  ///
  /// In en, this message translates to:
  /// **'Grow steady. The board will wait.'**
  String get dailyQuote2;

  /// No description provided for @dailyQuote3.
  ///
  /// In en, this message translates to:
  /// **'Collect what you can reach — leave the rest for next run.'**
  String get dailyQuote3;

  /// No description provided for @dailyQuote4.
  ///
  /// In en, this message translates to:
  /// **'Patience on the edges keeps the combo alive.'**
  String get dailyQuote4;

  /// No description provided for @dailyQuote5.
  ///
  /// In en, this message translates to:
  /// **'A short run with focus beats a long run on autopilot.'**
  String get dailyQuote5;

  /// No description provided for @dailyQuote6.
  ///
  /// In en, this message translates to:
  /// **'Every unlock began with a single eat.'**
  String get dailyQuote6;

  /// No description provided for @dailyQuote7.
  ///
  /// In en, this message translates to:
  /// **'Turn early. Celebrate later.'**
  String get dailyQuote7;

  /// No description provided for @dailyQuote8.
  ///
  /// In en, this message translates to:
  /// **'The board is fair — keep your path clear.'**
  String get dailyQuote8;

  /// No description provided for @dailyQuote9.
  ///
  /// In en, this message translates to:
  /// **'Slow is smooth. Smooth is fast.'**
  String get dailyQuote9;

  /// No description provided for @dailyQuote10.
  ///
  /// In en, this message translates to:
  /// **'Chase the rare treat, but respect the walls.'**
  String get dailyQuote10;

  /// No description provided for @dailyQuote11.
  ///
  /// In en, this message translates to:
  /// **'Today’s high score is tomorrow’s warm-up.'**
  String get dailyQuote11;

  /// No description provided for @dailyQuote12.
  ///
  /// In en, this message translates to:
  /// **'One more careful bite. That’s enough.'**
  String get dailyQuote12;

  /// No description provided for @dailyQuote13.
  ///
  /// In en, this message translates to:
  /// **'Length is pride — space is wisdom.'**
  String get dailyQuote13;

  /// No description provided for @dailyQuote14.
  ///
  /// In en, this message translates to:
  /// **'Breathe. Swipe. Grow.'**
  String get dailyQuote14;

  /// No description provided for @dailyQuote15.
  ///
  /// In en, this message translates to:
  /// **'Missed a turn? Restart with a smile.'**
  String get dailyQuote15;

  /// No description provided for @dailyQuote16.
  ///
  /// In en, this message translates to:
  /// **'Combos love calm hands.'**
  String get dailyQuote16;

  /// No description provided for @dailyQuote17.
  ///
  /// In en, this message translates to:
  /// **'The next level unlocks for the patient.'**
  String get dailyQuote17;

  /// No description provided for @dailyQuote18.
  ///
  /// In en, this message translates to:
  /// **'Play offline. Progress is yours.'**
  String get dailyQuote18;

  /// No description provided for @dailyQuote19.
  ///
  /// In en, this message translates to:
  /// **'Corners teach more than open fields.'**
  String get dailyQuote19;

  /// No description provided for @dailyQuote20.
  ///
  /// In en, this message translates to:
  /// **'A green path is a kind path — leave room to turn.'**
  String get dailyQuote20;

  /// No description provided for @dailyQuote21.
  ///
  /// In en, this message translates to:
  /// **'Epic food is loud. Soft turns win.'**
  String get dailyQuote21;

  /// No description provided for @dailyQuote22.
  ///
  /// In en, this message translates to:
  /// **'You don’t need perfect — just another try.'**
  String get dailyQuote22;

  /// No description provided for @dailyQuote23.
  ///
  /// In en, this message translates to:
  /// **'Wrap the board in your mind before you wrap the edge.'**
  String get dailyQuote23;

  /// No description provided for @dailyQuote24.
  ///
  /// In en, this message translates to:
  /// **'Rocks are teachers in disguise.'**
  String get dailyQuote24;

  /// No description provided for @dailyQuote25.
  ///
  /// In en, this message translates to:
  /// **'Champion looks follow champion habits.'**
  String get dailyQuote25;

  /// No description provided for @dailyQuote26.
  ///
  /// In en, this message translates to:
  /// **'Share the joy, keep the lessons.'**
  String get dailyQuote26;

  /// No description provided for @dailyQuote27.
  ///
  /// In en, this message translates to:
  /// **'Small grids, big focus.'**
  String get dailyQuote27;

  /// No description provided for @dailyQuote28.
  ///
  /// In en, this message translates to:
  /// **'The snake grows; so does your judgment.'**
  String get dailyQuote28;

  /// No description provided for @dailyQuote29.
  ///
  /// In en, this message translates to:
  /// **'Open again anytime — a new tip is waiting.'**
  String get dailyQuote29;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
