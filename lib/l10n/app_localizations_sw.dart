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
  String get startupCouldNotOpen => 'Imeshindwa kufungua Snake App';

  @override
  String get startupCouldNotOpenBody =>
      'Ufunguzi haujakamilika kwenye kifaa hiki. Jaribu tena.';

  @override
  String get tryAgain => 'Jaribu tena';

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
  String get home => 'Nyumbani';

  @override
  String get more => 'Zaidi';

  @override
  String get quickActions => 'Vitendo vya haraka';

  @override
  String get scoreboard => 'Ubao wa alama';

  @override
  String get homeWelcomeBack => 'Karibu tena';

  @override
  String get homeWelcomeGuest => 'Karibu';

  @override
  String get guestPlayer => 'Mgeni';

  @override
  String get homeWelcomeProfileHint => 'Wasifu wako · gusa kuhariri';

  @override
  String get homeWelcomeGuestHint => 'Gusa kuunda wasifu';

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
  String get fullNameRequired => 'Jina';

  @override
  String get emailOptional => 'Barua pepe';

  @override
  String get phoneOptional => 'Simu';

  @override
  String get usernameHint => 'Chagua jina la mchezaji';

  @override
  String get fullNameHint => 'Jina lako';

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
  String get fullNameRequiredError => 'Jina linahitajika';

  @override
  String get fullNameTooShort => 'Angalau herufi 2';

  @override
  String get fullNameTooLong => 'Si zaidi ya herufi 60';

  @override
  String get emailInvalid => 'Weka barua pepe sahihi';

  @override
  String get phoneInvalid => 'Weka nambari ya simu sahihi (tarakimu 7-15)';

  @override
  String get profileSaved => 'Wasifu umehifadhiwa kwenye kifaa';

  @override
  String get profileSavedWithScore =>
      'Wasifu umehifadhiwa - alama yako imehifadhiwa';

  @override
  String get selectAvatar => 'Chagua avatar';

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
      'Bado hakuna alama - maliza mchezo ili kuweka bora.';

  @override
  String get createProfileForScores =>
      'Unda wasifu ili kuhifadhi alama za juu nje ya mtandao.';

  @override
  String get newPersonalBest => 'Rekodi mpya binafsi!';

  @override
  String get saveScoreCreateProfile => 'Hifadhi alama - unda wasifu';

  @override
  String get onboardingWelcomeTitle => 'Karibu';

  @override
  String get onboardingWelcomeBody =>
      'Kua, kusanya, panda viwango - mchezo wa nyoka wa hali ya juu kwa kila skrini.';

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
  String get playFreelyHint => '· Cheza huru - wasifu huhifadhi alama';

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

  @override
  String get modeClassic => 'Klasiki';

  @override
  String get modeWrap => 'Kuzunguka';

  @override
  String get modeMaze => 'Labyrinth';

  @override
  String get modeWrapMaze => 'Kuzunguka + mawe';

  @override
  String get modeClassicTip => 'Kuta zinakomesha mchezo.';

  @override
  String get modeWrapTip => 'Kingo zinazunguka.';

  @override
  String get modeMazeTip => 'Mawe yanakomesha mchezo.';

  @override
  String get modeWrapMazeTip => 'Kingo zinazunguka - mawe bado yanakomesha.';

  @override
  String get onboardingMoveReverseHint => 'Huwezi kugeuka nyuma moja kwa moja.';

  @override
  String get snakeLook => 'Muonekano wa nyoka';

  @override
  String get snakeLookSubtitle => 'Ngozi za mapambo hufunguliwa kwa viwango';

  @override
  String get selectSnakeLook => 'Chagua muonekano';

  @override
  String skinLockedHint(int level) {
    return 'Fungua katika kiwango $level';
  }

  @override
  String get skinForest => 'Msitu';

  @override
  String get skinAmberLeaf => 'Jani la kahawia';

  @override
  String get skinRiver => 'Mto';

  @override
  String get skinSunset => 'Machweo';

  @override
  String get skinMidnight => 'Usiku';

  @override
  String get skinChampion => 'Bingwa';

  @override
  String skinUnlockedBanner(String skin) {
    return 'Muonekano mpya: $skin';
  }

  @override
  String get showDailyTip => 'Vidokezo na nukuu';

  @override
  String get showDailyTipSubtitle =>
      'Onyesha kidokezo kipya cha bahati kila unapofungua programu';

  @override
  String get dailyTipTitle => 'Kidokezo kwa ajili yako';

  @override
  String get dailyTipGotIt => 'Nimeelewa';

  @override
  String get shareScore => 'Shiriki kama picha';

  @override
  String get sharePreparing => 'Inatayarisha picha…';

  @override
  String get shareFailed => 'Imeshindwa kushiriki picha sasa. Jaribu tena.';

  @override
  String get shareSavedToDisk =>
      'Picha imehifadhiwa kwenye Downloads/Snake App - fungua hapo ili kushiriki.';

  @override
  String get sharePreviewTitle => 'Shiriki chapisho';

  @override
  String get sharePreviewSubtitle =>
      'Angalia picha kwanza, kisha ishiriki kwenye mitandao ya kijamii';

  @override
  String get shareAsImageConfirm => 'Shiriki picha';

  @override
  String get shareOverallBest => 'Shiriki alama bora kwa ujumla kama picha';

  @override
  String get shareCardPromo =>
      'Furaha nje ya mtandao · kua, kusanya, panda viwango';

  @override
  String get shareCardDownload => 'Pata Snake App kwenye Google Play';

  @override
  String get shareCardAvailableOn => 'Inapatikana kwenye';

  @override
  String get shareCardGooglePlay => 'Google Play';

  @override
  String get shareCardAppStore => 'App Store';

  @override
  String get shareCardDownloadBoth =>
      'Pakua bure kwenye Google Play na App Store';

  @override
  String get shareCardAchievements => 'Mchezo huu';

  @override
  String get shareCardOverallBestLabel => 'Alama yangu bora kwa ujumla';

  @override
  String shareCardOverallBestSummary(int score, int level) {
    return 'Bora $score · Kiwango $level kimefunguliwa';
  }

  @override
  String shareTextCaption(int score, int level) {
    return 'Nimepata alama $score kwenye Snake App (Kiwango $level)! Inapatikana kwenye Google Play na App Store.';
  }

  @override
  String shareTextOverallCaption(int score, int level) {
    return 'Alama yangu bora kwa ujumla kwenye Snake App ni $score (Kiwango $level kimefunguliwa)! Inapatikana kwenye Google Play na App Store.';
  }

  @override
  String get dailyQuote0 => 'Zamu ya uangalifu inashinda kasi isiyo na mpango.';

  @override
  String get dailyQuote1 => 'Alama yako bora ilianza kwa jaribio la kwanza.';

  @override
  String get dailyQuote2 => 'Kua polepole. Uwanja utangoja.';

  @override
  String get dailyQuote3 =>
      'Kusanya unachoweza kufikia - wacha mengine kwa mchezo ujao.';

  @override
  String get dailyQuote4 => 'Subira kwenye kingo huweka mfululizo hai.';

  @override
  String get dailyQuote5 =>
      'Mchezo mfupi wenye umakini unashinda mrefu bila mpango.';

  @override
  String get dailyQuote6 => 'Kila ufunguzi ulianza kwa kula moja.';

  @override
  String get dailyQuote7 => 'Geuka mapema. Sherehekea baadaye.';

  @override
  String get dailyQuote8 => 'Uwanja ni wa haki - weka njia wazi.';

  @override
  String get dailyQuote9 => 'Polepole ni laini. Laini ni haraka.';

  @override
  String get dailyQuote10 => 'Fuata kitoweo adimu, lakini heshimu kuta.';

  @override
  String get dailyQuote11 => 'Alama ya juu ya leo ni mazoezi ya kesho.';

  @override
  String get dailyQuote12 => 'Kilo kingine cha uangalifu. Kinatosha.';

  @override
  String get dailyQuote13 => 'Urefu ni fahari - nafasi ni hekima.';

  @override
  String get dailyQuote14 => 'Pumua. Telezesha. Kua.';

  @override
  String get dailyQuote15 => 'Umekosa zamu? Anza upya kwa tabasamu.';

  @override
  String get dailyQuote16 => 'Mifululizo inapenda mikono tulivu.';

  @override
  String get dailyQuote17 =>
      'Kiwango kinachofuata hufunguliwa kwa wenye subira.';

  @override
  String get dailyQuote18 => 'Cheza nje ya mtandao. Maendeleo ni yako.';

  @override
  String get dailyQuote19 => 'Pembe hufundisha zaidi kuliko uwanja wazi.';

  @override
  String get dailyQuote20 =>
      'Njia ya kijani ni njia ya fadhili - acha nafasi ya kugeuka.';

  @override
  String get dailyQuote21 =>
      'Chakula cha kipekee ni cha kelele. Zamu laini hushinda.';

  @override
  String get dailyQuote22 => 'Huhitaji ukamilifu - jaribio jingine tu.';

  @override
  String get dailyQuote23 => 'Fikiria uwanja kabla ya kuzunguka kingo.';

  @override
  String get dailyQuote24 => 'Mawe ni walimu waliovalia siri.';

  @override
  String get dailyQuote25 => 'Muonekano wa bingwa unafuata tabia za bingwa.';

  @override
  String get dailyQuote26 => 'Shiriki furaha, hifadhi masomo.';

  @override
  String get dailyQuote27 => 'Gridi ndogo, umakini mkubwa.';

  @override
  String get dailyQuote28 => 'Nyoka anakua; hukumu yako pia.';

  @override
  String get dailyQuote29 =>
      'Fungua tena wakati wowote - kidokezo kipya kinakungoja.';

  @override
  String get challenges => 'Changamoto';

  @override
  String get challengesIntro =>
      'Nyoka yule yule, sababu mpya za kucheza. Kampeni inabaki chini ya Cheza.';

  @override
  String get quitToChallenges => 'Rudi kwenye changamoto';

  @override
  String get challengeCleared => 'Umeshinda';

  @override
  String get timer => 'Muda';

  @override
  String get lengthLabel => 'Urefu';

  @override
  String get targets => 'Malengo';

  @override
  String get shield => 'Ngao';

  @override
  String get dashHold => 'Kimbia';

  @override
  String get handToNext => 'Mpe simu mchezaji anayefuata';

  @override
  String get continuePlay => 'Endelea';

  @override
  String get showGhost => 'Onyesha kivuli';

  @override
  String get showGhostSubtitle =>
      'Njia hafifu ya alama yako bora kwenye kifaa hiki';

  @override
  String get challengeScores => 'Changamoto';

  @override
  String get playChallengePrompt =>
      'Cheza changamoto ili kuhifadhi alama bora hapa.';

  @override
  String get noChallengeBest => 'Bado hakuna alama bora';

  @override
  String bestScoreValue(int score) {
    return 'Bora $score';
  }

  @override
  String get sectionTimed => 'Kwa muda';

  @override
  String get sectionPractice => 'Mazoezi';

  @override
  String get sectionBoard => 'Uwanja';

  @override
  String get sectionClutch => 'Uokoaji';

  @override
  String get sectionToday => 'Kifaa hiki, leo';

  @override
  String get sectionExpert => 'Mtaalamu';

  @override
  String get tipTimed => 'Pata alama nyingi kabla muda haujaisha.';

  @override
  String get tipZen => 'Hakuna viwango - kua tu.';

  @override
  String get tipCollector => 'Kula malengo yaliyowekwa ili kushinda.';

  @override
  String get tipClearGrove => 'Kula kila kokwa kwenye shamba.';

  @override
  String get tipPeaceful => 'Jaza uwanja. Huwezi kugonga.';

  @override
  String get tipArena => 'Dumu kuliko nyoka wengine kwenye kifaa hiki.';

  @override
  String get tipScore => 'Kua, kusanya, na endelea kusonga.';

  @override
  String get challengeSprint60 => 'Mbio za sekunde 60';

  @override
  String get challengeSprint90 => 'Mbio za sekunde 90';

  @override
  String get challengeSprintOpen => 'Mbio za kuzunguka';

  @override
  String get challengeZen => 'Utulivu';

  @override
  String get challengeZenWrap => 'Utulivu unaozunguka';

  @override
  String get challengeCollector => 'Mkusanyaji';

  @override
  String get challengeBonus => 'Mnyama wa bonasi';

  @override
  String get challengeGrowing => 'Kuta zinazokua';

  @override
  String get challengeBurrows => 'Mashimo';

  @override
  String get challengeBitter => 'Tunda chungu';

  @override
  String get challengeKey => 'Tunda la ufunguo';

  @override
  String get challengeShieldDash => 'Ngao na mbio';

  @override
  String get challengeHotSeat => 'Mbio za kupokezana';

  @override
  String get challengeClearGrove => 'Safisha shamba';

  @override
  String get challengeShed => 'Ngozi iliyomwagika';

  @override
  String get challengePeaceful => 'Kujaza kwa amani';

  @override
  String get challengeFleeing => 'Chakula kinachokimbia';

  @override
  String get challengeLantern => 'Taa';

  @override
  String get challengeVine => 'Njia ya mzabibu';

  @override
  String get challengeMixBitter => 'Kuzunguka na tunda chungu';

  @override
  String get challengeMixBonus => 'Mazingira na bonasi';

  @override
  String get challengeArena => 'Uwanja wa shamba';

  @override
  String get challengeDaily => 'Shamba la leo';
}
