import 'package:flutter/material.dart';

/// UnTense brand colors extracted from the official logo.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────
  static const Color primary = Color(0xFF0B1F4A);
  static const Color primarySoft = Color(0xFF1A3360);
  static const Color secondary = Color(0xFF2DB5AE);
  static const Color secondarySoft = Color(0xFF5CC9C3);
  static const Color secondaryMuted = Color(0xFFE6F7F6);

  // ── Surfaces ───────────────────────────────────────────
  static const Color background = Color(0xFFF7F6F3);
  static const Color backgroundWarm = Color(0xFFFBF9F6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  // ── Text ───────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0B1F4A);
  static const Color textSecondary = Color(0xFF5A6A85);
  static const Color textMuted = Color(0xFF8B97AB);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // ── UI ─────────────────────────────────────────────────
  static const Color divider = Color(0xFFE8E6E1);
  static const Color border = Color(0xFFE2E0DB);
  static const Color shadow = Color(0x140B1F4A);
  static const Color indicatorInactive = Color(0xFFD5D9E2);
  static const Color success = Color(0xFF2DB5AE);
  static const Color error = Color(0xFFE85A5A);

  // ── Gradients ──────────────────────────────────────────
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient softGlowGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE8F6F5), background],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, Color(0xFF164066)],
  );

  static const LinearGradient tealGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondarySoft, secondary],
  );
}
