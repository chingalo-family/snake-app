// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appName => 'Snake App';

  @override
  String get tagline => 'Kua, kusanya, panda viwango';

  @override
  String get play => 'Cheza';

  @override
  String get levels => 'Viwango';

  @override
  String get scores => 'Alama';

  @override
  String get highScores => 'Alama za juu';

  @override
  String get profile => 'Wasifu';

  @override
  String get createProfile => 'Unda wasifu';

  @override
  String get settings => 'Mipangilio';

  @override
  String get about => 'Kuhusu';

  @override
  String get skip => 'Ruka';

  @override
  String get next => 'Endelea';

  @override
  String get back => 'Rudi';

  @override
  String get getStarted => 'Anza';

  @override
  String pageOf(int current, int total) {
    return '$current/$total';
  }

  @override
  String get start => 'Anza';

  @override
  String get save => 'Hifadhi';

  @override
  String get saving => 'Inahifadhi…';

  @override
  String get resume => 'Endelea';

  @override
  String get restart => 'Anza upya';

  @override
  String get quitToLevels => 'Rudi kwenye viwango';

  @override
  String get playAgain => 'Cheza tena';

  @override
  String get backToLevels => 'Rudi kwenye viwango';

  @override
  String get playAnyway => 'Cheza bila wasifu';

  @override
  String get pause => 'Simamisha';

  @override
  String get paused => 'Imesimamishwa';

  @override
  String get gameOver => 'Mchezo umeisha';

  @override
  String get score => 'Alama';

  @override
  String get level => 'Kiwango';

  @override
  String get combo => 'Mfululizo';

  @override
  String get stats => 'Takwimu';

  @override
  String get eaten => 'Zilizoliwa';

  @override
  String get last => 'Mwisho';

  @override
  String get version => 'Toleo';

  @override
  String get build => 'Jengo';

  @override
  String get package => 'Kifurushi';

  @override
  String get madeBy => 'Imetengenezwa na';

  @override
  String get highlights => 'Vipengele';

  @override
  String get audio => 'Sauti';

  @override
  String get feel => 'Hisia';

  @override
  String get display => 'Onyesho';

  @override
  String get appSection => 'Programu';

  @override
  String get language => 'Lugha';

  @override
  String get english => 'English';

  @override
  String get swahili => 'Kiswahili';

  @override
  String get theme => 'Mandhari';

  @override
  String get themeSystem => 'Mfumo';

  @override
  String get themeLight => 'Angavu';

  @override
  String get themeDark => 'Giza';

  @override
  String get soundEffects => 'Athari za sauti';

  @override
  String get soundEffectsSubtitle => 'Kula, kugongana, na mguso wa skrini';

  @override
  String get backgroundMusic => 'Muziki wa nyuma';

  @override
  String get backgroundMusicSubtitle => 'Huru kutoka kwa athari za sauti';

  @override
  String get hapticFeedback => 'Mitetemo';

  @override
  String get hapticFeedbackSubtitle => 'Simu pekee';

  @override
  String get showControlHints => 'Onyesha vidokezo vya udhibiti';

  @override
  String get showControlHintsSubtitle => 'Vidokezo vya kutelezesha na kibodi';

  @override
  String get selectLanguage => 'Chagua lugha';

  @override
  String appDisplayLanguage(String language) {
    return 'Lugha ya programu: $language';
  }

  @override
  String get aboutSubtitle => 'Toleo, sifa, na vipengele';

  @override
  String get checkForUpdates => 'Angalia masasisho';

  @override
  String get checkForUpdatesSubtitle => 'Hufungua Google Play au App Store';

  @override
  String get checkForUpdatesSubtitleAndroid => 'Hufungua Google Play';

  @override
  String get checkForUpdatesSubtitleIos => 'Hufungua App Store';

  @override
  String get checkedUpdates => 'Masasisho yameangaliwa';

  @override
  String get usernameRequired => 'Jina la mtumiaji';

  @override
  String get fullNameRequired => 'Jina kamili';

  @override
  String get emailOptional => 'Barua pepe';

  @override
  String get phoneOptional => 'Simu';

  @override
  String get usernameHint => 'Chagua jina la mchezaji';

  @override
  String get fullNameHint => 'Jina lako kamili';

  @override
  String get emailHint => 'jina@mfano.com';

  @override
  String get phoneHint => 'mf. +255712345678';

  @override
  String get usernameRequiredError => 'Jina la mtumiaji linahitajika';

  @override
  String get usernameTooShort => 'Angalau herufi 2';

  @override
  String get usernameTooLong => 'Si zaidi ya herufi 24';

  @override
  String get usernameInvalid =>
      'Tumia herufi, nambari, na alama ya chini pekee';

  @override
  String get fullNameRequiredError => 'Jina kamili linahitajika';

  @override
  String get fullNameTooShort => 'Angalau herufi 2';

  @override
  String get fullNameTooLong => 'Si zaidi ya herufi 60';

  @override
  String get emailInvalid => 'Weka barua pepe sahihi';

  @override
  String get phoneInvalid => 'Weka nambari ya simu sahihi (tarakimu 7–15)';

  @override
  String get profileSaved => 'Wasifu umehifadhiwa kwenye kifaa';

  @override
  String get profileHelp =>
      'Wasifu unahitajika tu kuhifadhi alama za juu na maendeleo ya viwango. Unaweza kucheza bila wasifu.';

  @override
  String get best => 'Bora';

  @override
  String get games => 'Michezo';

  @override
  String get overallBest => 'Alama bora kwa ujumla';

  @override
  String get perLevel => 'Kwa kiwango';

  @override
  String get noScoresYet =>
      'Bado hakuna alama — maliza mchezo ili kuweka bora.';

  @override
  String get createProfileForScores =>
      'Unda wasifu ili kuhifadhi alama za juu nje ya mtandao.';

  @override
  String get newPersonalBest => 'Rekodi mpya binafsi!';

  @override
  String get saveScoreCreateProfile => 'Hifadhi alama — unda wasifu';

  @override
  String get onboardingWelcomeTitle => 'Karibu';

  @override
  String get onboardingWelcomeBody =>
      'Kua, kusanya, panda viwango — mchezo wa nyoka wa hali ya juu kwa kila skrini.';

  @override
  String get onboardingMoveTitle => 'Jinsi ya kusogeza';

  @override
  String get onboardingMoveTouch =>
      'Telezesha juu, chini, kushoto, au kulia. Epuka kuta na mkia wako.';

  @override
  String get onboardingMoveDesktop =>
      'Tumia funguo za mishale (au WASD). Esc inasimamisha.';

  @override
  String get onboardingCollectTitle => 'Kusanya na pata alama';

  @override
  String get onboardingCollectBody =>
      'Wanyama na vitoweo vina alama tofauti. Kula mfululizo kwa bonasi ya mfululizo.';

  @override
  String get onboardingProfileTitle => 'Viwango na wasifu';

  @override
  String get onboardingProfileBody =>
      'Fungua viwango unavyoboresha. Unda wasifu wa ndani ili kuhifadhi alama za juu nje ya mtandao.';

  @override
  String get hintSwipe => 'Telezesha ili kusogeza';

  @override
  String get hintKeyboard => 'Mishale / WASD kusogeza · Esc simamisha';

  @override
  String get playFreelyHint => '· Cheza huru — wasifu huhifadhi alama';

  @override
  String get aboutDescription =>
      'Mchezo wa nyoka wa kuvutia, unaofanya kazi nje ya mtandao, wenye uwanja unaobadilika, vitu vya kukusanya, viwango, na alama za juu za ndani.';

  @override
  String get highlightSwipe =>
      '• Telezesha kwenye mguso, mishale kwenye kompyuta';

  @override
  String get highlightOrientation => '• Uwanja wa wima na mlalo';

  @override
  String get highlightAudio => '• Vipengele tofauti vya athari na muziki';

  @override
  String get highlightProfile => '• Alama zilizohifadhiwa zinahitaji wasifu';

  @override
  String get densityDense => 'Msongamano mkubwa';

  @override
  String get densityStandard => 'Kawaida';

  @override
  String get densitySpacious => 'Nafasi kubwa';

  @override
  String get speedVeryFast => 'Haraka sana';

  @override
  String get speedFast => 'Haraka';

  @override
  String get speedMedium => 'Wastani';

  @override
  String get speedSlow => 'Polepole';

  @override
  String levelUnlocked(int level) {
    return 'Kiwango $level kimefunguliwa';
  }

  @override
  String levelNumber(int level) {
    return 'Kiwango $level';
  }

  @override
  String levelUnlockHint(int score, int level) {
    return 'Alama $score+ kwenye kiwango $level';
  }

  @override
  String scoreLevelSummary(int score, int level) {
    return 'Alama $score · Kiwango $level';
  }

  @override
  String bestComboSuffix(int combo) {
    return ' · Mfululizo bora x$combo';
  }

  @override
  String levelUnlockedBanner(int level) {
    return 'Kiwango $level kimefunguliwa!';
  }

  @override
  String highestLevelCombo(int level, int combo) {
    return 'Kiwango cha juu $level · Mfululizo bora x$combo';
  }

  @override
  String scoreLabelValue(int score) {
    return 'Alama $score';
  }

  @override
  String levelLabelValue(int level) {
    return 'Kiwango $level';
  }

  @override
  String eatenLabelValue(int count) {
    return 'Zilizoliwa $count';
  }

  @override
  String lastLabelValue(String icon) {
    return 'Mwisho $icon';
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
    return 'Una toleo $version.';
  }

  @override
  String updateOpenPlayStore(String version) {
    return 'Inafungua Google Play kwa toleo $version.';
  }

  @override
  String updateOpenAppStore(String version) {
    return 'Inafungua App Store kwa toleo $version.';
  }

  @override
  String get updateUnsupported =>
      'Masasisho ya duka yanapatikana kwenye Android na iOS pekee.';

  @override
  String errorWithDetails(String details) {
    return 'Hitilafu: $details';
  }
}
