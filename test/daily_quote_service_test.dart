import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake_app/core/constants/preference_keys.dart';
import 'package:snake_app/core/services/daily_quote_service.dart';
import 'package:snake_app/core/services/preference_service.dart';
import 'package:snake_app/l10n/app_localizations_en.dart';

void main() {
  group('DailyQuoteService', () {
    test('picks a random session quote and keeps it stable', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final service = DailyQuoteService(
        PreferenceService(preferences),
        random: Random(42),
      );
      final l10n = AppLocalizationsEn();
      final first = service.sessionQuote(l10n);
      final second = service.sessionQuote(l10n);
      expect(first, isNotEmpty);
      expect(second, first);
    });

    test('persists last quote index for the next launch', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final service = DailyQuoteService(
        PreferenceService(preferences),
        random: Random(42),
      );
      service.sessionQuote(AppLocalizationsEn());
      
      await Future<void>.delayed(Duration.zero);
      expect(
        preferences.getInt(PreferenceKeys.dailyQuoteLastIndex),
        isNotNull,
      );
    });

    test('skips the previous index when random would repeat it', () async {
      SharedPreferences.setMockInitialValues({
        PreferenceKeys.dailyQuoteLastIndex: 3,
      });
      final preferences = await SharedPreferences.getInstance();
      final service = DailyQuoteService(
        PreferenceService(preferences),
        random: _AlwaysReturns(3),
      );
      service.debugSetSessionQuoteIndex(0); 
      
      final freshService = DailyQuoteService(
        PreferenceService(preferences),
        random: _AlwaysReturns(3),
      );
      freshService.sessionQuote(AppLocalizationsEn());
      await Future<void>.delayed(Duration.zero);
      expect(
        preferences.getInt(PreferenceKeys.dailyQuoteLastIndex),
        isNot(3),
      );
    });

    test('dismiss hides the card for this session only', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final service = DailyQuoteService(
        PreferenceService(preferences),
        random: Random(7),
      );

      expect(service.shouldShowCard(dailyTipEnabled: true), isTrue);
      service.dismissForSession();
      expect(service.shouldShowCard(dailyTipEnabled: true), isFalse);
    });

    test('disabled tip never shows', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final service = DailyQuoteService(PreferenceService(preferences));
      expect(service.shouldShowCard(dailyTipEnabled: false), isFalse);
    });

    test('new launch can show a different quote', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final preferenceService = PreferenceService(preferences);
      final l10n = AppLocalizationsEn();

      final firstLaunch = DailyQuoteService(
        preferenceService,
        random: Random(1),
      );
      final firstQuote = firstLaunch.sessionQuote(l10n);

      final secondLaunch = DailyQuoteService(
        preferenceService,
        random: Random(99),
      );
      final secondQuote = secondLaunch.sessionQuote(l10n);

      expect(firstQuote, isNot(secondQuote));
    });
  });
}

class _AlwaysReturns implements Random {
  _AlwaysReturns(this.value);

  final int value;

  @override
  int nextInt(int max) => value % max;

  @override
  double nextDouble() => 0;

  @override
  bool nextBool() => false;
}
