import 'package:flutter/material.dart';

/// Brand and surface tokens — see docs/THEME_AND_COLORS.md
abstract final class AppColors {
  static const Color brandPrimary = Color(0xFF1FA87A);
  static const Color brandPrimaryDark = Color(0xFF14825C);
  static const Color brandPrimaryLight = Color(0xFF3ECF98);
  static const Color brandSecondary = Color(0xFFF0A202);
  static const Color brandSecondaryMuted = Color(0xFFD4890A);
  static const Color brandDanger = Color(0xFFE85D4C);
  static const Color brandInfo = Color(0xFF3D8BFD);

  static const Color darkBg = Color(0xFF0B1F1A);
  static const Color darkRaised = Color(0xFF12352C);
  static const Color darkBoard = Color(0xFF0F2A23);
  static const Color darkGridLine = Color(0xFF1A4338);
  static const Color darkTextPrimary = Color(0xFFF2F7F4);
  static const Color darkTextSecondary = Color(0xFFA8C4B8);
  static const Color darkTextMuted = Color(0xFF6F8F82);

  static const Color lightBg = Color(0xFFF3F8F5);
  static const Color lightRaised = Color(0xFFFFFFFF);
  static const Color lightBoard = Color(0xFFE5F2EB);
  static const Color lightGridLine = Color(0xFFC5DCD0);
  static const Color lightTextPrimary = Color(0xFF0F2A23);
  static const Color lightTextSecondary = Color(0xFF3D5C50);
  static const Color lightTextMuted = Color(0xFF6A8579);

  static const LinearGradient darkAtmosphere = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBg, darkRaised, darkBg],
  );

  static const LinearGradient lightAtmosphere = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightBg, Color(0xFFE8F3EC), lightBg],
  );
}
