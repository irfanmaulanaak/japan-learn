import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Surfaces
  static const bg = Color(0xFFFBFAF7);
  static const surface = Color(0xFFFFFFFF);

  // Ink (warm dark, not pure black)
  static const ink = Color(0xFF2A2520);
  static const inkSoft = Color(0xFF6B645C);
  static const inkMuted = Color(0xFFA39B92);

  // Single brand accent: persimmon (柿色)
  static const accent = Color(0xFFE8763E);
  static const accentDark = Color(0xFFC45A28);
  static const accentTint = Color(0xFFFBE8DC);

  // Soft module tints (used as backgrounds, never borders)
  static const tintSage = Color(0xFFE8F0E4);
  static const tintSky = Color(0xFFE2EDF5);
  static const tintLavender = Color(0xFFEDE6F4);

  // States
  static const success = Color(0xFF3F8D5B);
  static const danger = Color(0xFFD9533F);

  // Hairline (used sparingly)
  static const hairline = Color(0xFFEFECE6);
}

/// Latin glyphs render in Plus Jakarta Sans; anything it lacks (i.e. all
/// Japanese) falls through to the bundled Noto Sans JP so kana/kanji look the
/// same on every device instead of leaning on the OS fallback.
const _jpFallback = ['NotoSansJP'];

ThemeData buildAppTheme() {
  final base = GoogleFonts.plusJakartaSansTextTheme();
  final textTheme = base.apply(
    bodyColor: AppColors.ink,
    displayColor: AppColors.ink,
    fontFamilyFallback: _jpFallback,
  );

  return ThemeData(
    useMaterial3: true,
    fontFamilyFallback: _jpFallback,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      onPrimary: Colors.white,
      secondary: AppColors.accentDark,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      error: AppColors.danger,
    ),
    textTheme: textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
      ),
      headlineMedium: textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      titleLarge: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      titleMedium: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      bodyLarge: textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.inkSoft,
      ),
      bodyMedium: textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.inkSoft,
      ),
      labelLarge: textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bg,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.ink,
        fontWeight: FontWeight.w800,
        fontSize: 22,
        letterSpacing: -0.3,
      ).copyWith(fontFamilyFallback: _jpFallback),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
