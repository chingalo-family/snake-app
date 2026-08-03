import 'package:flutter/material.dart';

/// Supported app languages. English is the default.
abstract final class AppLocale {
  static const String englishCode = 'en';
  static const String swahiliCode = 'sw';

  static const List<Locale> supportedLocales = [
    Locale(englishCode),
    Locale(swahiliCode),
  ];

  static Locale fromCode(String code) {
    return Locale(normalizeCode(code));
  }

  static String normalizeCode(String code) {
    if (code == swahiliCode) return swahiliCode;
    return englishCode;
  }
}
