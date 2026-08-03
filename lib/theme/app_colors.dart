import 'package:flutter/material.dart';

/// Palette Muravera Ricicla — blu/turchese mediterraneo, richiama il
/// calendario cartaceo COSIR.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF071823);
  static const Color surface = Color(0xFF0E2A3A);
  static const Color surfaceHigh = Color(0xFF14384C);

  static const Color primary = Color(0xFF2BB3E0);
  static const Color accent = Color(0xFF19C3A6);

  static const Color glass = Color(0x14FFFFFF);
  static const Color glassStrong = Color(0x2AFFFFFF);
  static const Color hairline = Color(0x1FFFFFFF);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF);
  static const Color textMuted = Color(0x7AFFFFFF);

  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF5350);

  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF12455E), background, background],
    stops: [0.0, 0.35, 1.0],
  );
}
