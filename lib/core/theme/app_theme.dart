import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_app/core/theme/app_colors.dart';

abstract final class AppTheme {
  static const String _fontFamily = 'Nunito';

  /// Same density on phone, tablet, and desktop so dark/light look identical.
  static const VisualDensity _visualDensity = VisualDensity.standard;

  static ThemeData dark() {
    final baseText = ThemeData.dark().textTheme.apply(
      fontFamily: _fontFamily,
      bodyColor: AppColors.darkTextPrimary,
      displayColor: AppColors.darkTextPrimary,
    );
    final colorScheme = ColorScheme.dark(
      primary: AppColors.brandPrimary,
      onPrimary: AppColors.darkBg,
      secondary: AppColors.brandSecondary,
      onSecondary: AppColors.darkBg,
      error: AppColors.brandDanger,
      onError: AppColors.darkTextPrimary,
      surface: AppColors.darkRaised,
      onSurface: AppColors.darkTextPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      visualDensity: _visualDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkBg,
      canvasColor: AppColors.darkBg,
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkRaised,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkRaised,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.darkRaised,
      ),
      textTheme: baseText,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.darkTextPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: baseText.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkRaised,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brandPrimary,
          foregroundColor: AppColors.darkBg,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: AppColors.darkGridLine),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkTextSecondary,
          minimumSize: const Size(48, 48),
        ),
      ),
      switchTheme: _switchTheme(isDark: true),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: AppColors.darkTextSecondary,
        textColor: AppColors.darkTextPrimary,
      ),
      dividerColor: AppColors.darkGridLine,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkRaised,
        contentTextStyle: baseText.bodyMedium?.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.darkRaised),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
    );
  }

  static ThemeData light() {
    final baseText = ThemeData.light().textTheme.apply(
      fontFamily: _fontFamily,
      bodyColor: AppColors.lightTextPrimary,
      displayColor: AppColors.lightTextPrimary,
    );
    final colorScheme = ColorScheme.light(
      primary: AppColors.brandPrimary,
      onPrimary: Colors.white,
      secondary: AppColors.brandSecondary,
      onSecondary: AppColors.lightTextPrimary,
      error: AppColors.brandDanger,
      onError: Colors.white,
      surface: AppColors.lightRaised,
      onSurface: AppColors.lightTextPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _fontFamily,
      visualDensity: _visualDensity,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBg,
      canvasColor: AppColors.lightBg,
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightRaised,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightRaised,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.lightRaised,
      ),
      textTheme: baseText,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.lightTextPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: baseText.titleLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightRaised,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brandPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightTextPrimary,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: AppColors.lightGridLine),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightTextSecondary,
          minimumSize: const Size(48, 48),
        ),
      ),
      switchTheme: _switchTheme(isDark: false),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        iconColor: AppColors.lightTextSecondary,
        textColor: AppColors.lightTextPrimary,
      ),
      dividerColor: AppColors.lightGridLine,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightRaised,
        contentTextStyle: baseText.bodyMedium?.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.lightRaised),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ),
    );
  }

  static SwitchThemeData _switchTheme({required bool isDark}) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.brandPrimaryLight;
        }
        return isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.brandPrimary.withValues(alpha: 0.5);
        }
        return isDark ? AppColors.darkGridLine : AppColors.lightGridLine;
      }),
    );
  }
}
