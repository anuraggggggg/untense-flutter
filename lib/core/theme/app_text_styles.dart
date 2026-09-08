import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_colors.dart';

/// Premium typography system for UnTense.
abstract final class AppTextStyles {
  // ── Display / Hero ─────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 1.15,
        letterSpacing: -1.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        height: 1.18,
        letterSpacing: -0.8,
        color: AppColors.textPrimary,
      );

  // ── Headings ───────────────────────────────────────────
  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.6,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      );

  // ── Body ───────────────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.55,
        letterSpacing: 0.1,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.textMuted,
      );

  // ── Labels / Buttons ───────────────────────────────────
  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0.2,
        color: AppColors.textOnPrimary,
      );

  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 0.3,
        color: AppColors.textMuted,
      );

  static TextStyle get caption => labelSmall;

  static TextStyle get button => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.15,
        color: AppColors.textOnPrimary,
      );

  static TextStyle get skip => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AppColors.textMuted,
      );

  /// Material 3 TextTheme mapped to UnTense styles.
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
        titleLarge: headlineSmall,
        titleMedium: labelMedium,
        titleSmall: labelSmall,
      );
}
