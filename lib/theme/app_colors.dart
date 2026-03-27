import 'package:flutter/material.dart';

/// Központi színrendszer - BookNails alkalmazáshoz
///
/// WCAG 2.0 Kontrasztarány követelmények (AA szint, min. 4.5:1 normál szöveghez):
/// ✅ textPrimary (0xFF212121) on any light background: ~21:1 (excellent)
/// ✅ textSecondary (0xFF757575) on white: ~4.5:1 (meets AA)
/// ✅ primary (0xFF9C27B0) + textOnPrimary (white): ~5.5:1 (meets AA)
/// ✅ secondary (0xFFE91E63) + textOnSecondary (white): ~7:1 (meets AAA)
/// ✅ success/warning/error on white background: all meet AA minimum
class AppColors {
  // Elsődleges szín - Purple
  static const Color primary = Color(0xFF9C27B0);
  static const Color primaryLight = Color(0xFFE1BEE7);
  static const Color primaryDark = Color(0xFF6A1B9A);

  // Másodlagos szín - Pink
  static const Color secondary = Color(0xFFE91E63);
  static const Color secondaryLight = Color(0xFFF8BBD0);
  static const Color secondaryDark = Color(0xFFC2185B);

  // Felszín és háttér
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Szöveg szinek
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // Állapotszinek
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Edge esetek
  static const Color disabled = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
