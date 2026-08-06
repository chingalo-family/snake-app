import 'dart:math';

import 'package:snake_app/core/constants/preference_keys.dart';
import 'package:snake_app/core/services/preference_service.dart';
import 'package:snake_app/l10n/app_localizations.dart';

class DailyQuoteService {
  DailyQuoteService(this._preferenceService, {Random? random})
      : _random = random ?? Random();

  final PreferenceService _preferenceService;
  final Random _random;

  static const quoteCount = 30;

  int? _sessionQuoteIndex;
  bool _dismissedThisSession = false;

  bool get isDismissedThisSession => _dismissedThisSession;

  bool shouldShowCard({required bool dailyTipEnabled}) {
    if (!dailyTipEnabled) return false;
    return !_dismissedThisSession;
  }

  
  String sessionQuote(AppLocalizations l10n) {
    return _quoteAt(l10n, _ensureSessionQuoteIndex());
  }

  int _ensureSessionQuoteIndex() {
    final existingIndex = _sessionQuoteIndex;
    if (existingIndex != null) return existingIndex;

    final previousIndex =
        _preferenceService.getInt(PreferenceKeys.dailyQuoteLastIndex);
    var nextIndex = _random.nextInt(quoteCount);
    if (previousIndex != null &&
        quoteCount > 1 &&
        nextIndex == previousIndex) {
      nextIndex = (nextIndex + 1 + _random.nextInt(quoteCount - 1)) % quoteCount;
    }
    _sessionQuoteIndex = nextIndex;
    
    _preferenceService.setInt(PreferenceKeys.dailyQuoteLastIndex, nextIndex);
    return nextIndex;
  }

  void dismissForSession() {
    _dismissedThisSession = true;
  }

  
  void debugSetSessionQuoteIndex(int quoteIndex) {
    _sessionQuoteIndex = quoteIndex % quoteCount;
  }

  String _quoteAt(AppLocalizations l10n, int quoteIndex) {
    return switch (quoteIndex % quoteCount) {
      0 => l10n.dailyQuote0,
      1 => l10n.dailyQuote1,
      2 => l10n.dailyQuote2,
      3 => l10n.dailyQuote3,
      4 => l10n.dailyQuote4,
      5 => l10n.dailyQuote5,
      6 => l10n.dailyQuote6,
      7 => l10n.dailyQuote7,
      8 => l10n.dailyQuote8,
      9 => l10n.dailyQuote9,
      10 => l10n.dailyQuote10,
      11 => l10n.dailyQuote11,
      12 => l10n.dailyQuote12,
      13 => l10n.dailyQuote13,
      14 => l10n.dailyQuote14,
      15 => l10n.dailyQuote15,
      16 => l10n.dailyQuote16,
      17 => l10n.dailyQuote17,
      18 => l10n.dailyQuote18,
      19 => l10n.dailyQuote19,
      20 => l10n.dailyQuote20,
      21 => l10n.dailyQuote21,
      22 => l10n.dailyQuote22,
      23 => l10n.dailyQuote23,
      24 => l10n.dailyQuote24,
      25 => l10n.dailyQuote25,
      26 => l10n.dailyQuote26,
      27 => l10n.dailyQuote27,
      28 => l10n.dailyQuote28,
      _ => l10n.dailyQuote29,
    };
  }
}
