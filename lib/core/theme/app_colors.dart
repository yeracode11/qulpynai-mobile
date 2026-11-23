import 'package:flutter/widgets.dart';

/// Brand palette taken from the Qulpynai design (globals.css / DESIGN_SYSTEM.md).
abstract final class AppColors {
  // Actions
  /// Action red. Slightly deeper than the web brand #E42F30 so white
  /// button text passes WCAG AA (5.0:1).
  static const red = Color(0xFFD42A2B);
  static const redBrand = Color(0xFFE42F30);
  static const redDark = Color(0xFFB8211F);
  static const redSoft = Color(0xFFFFDEDC);
  static const orange = Color(0xFFC2340F);

  // Accent (tiffany)
  static const teal = Color(0xFF00ACA8);
  static const tealDark = Color(0xFF006E6E);

  /// Teal deep enough for white text on it (5.2:1).
  static const tealDeep = Color(0xFF007A7A);
  static const tealInk = Color(0xFF2E4A4A);
  static const tealSoft = Color(0xFFCDEFEC);

  // Freshness
  static const green = Color(0xFF529032);

  /// Green for text and white-on-green fills (5.2:1).
  static const greenText = Color(0xFF3F7A26);
  static const greenDark = Color(0xFF3E6E25);
  static const greenInk = Color(0xFF2F5A1C);
  static const greenSoft = Color(0xFFDDEFC9);

  // Warm neutrals
  static const ink = Color(0xFF1F1A17);
  static const inkSoft = Color(0xFF4A4340);
  static const inkBody = Color(0xFF2E2825);

  /// Secondary text: 5.1:1 on the warm background (was #8B8B8B, 3.1:1).
  static const muted = Color(0xFF6E6762);

  /// Placeholder / disabled glyphs and decorative icons only.
  static const faint = Color(0xFF9C938D);
  static const line = Color(0xFFEBEBEB);
  static const divider = Color(0xFFF1ECE7);

  /// Borders of controls (checkbox, radio): 3:1 against white.
  static const outline = Color(0xFF9C938D);
  static const outlineSoft = Color(0xFFD9D2CC);
  static const bg = Color(0xFFF7F4F1);
  static const bgDeep = Color(0xFFEDE8E3);
  static const cream = Color(0xFFFAE3C4);
  static const brown = Color(0xFF7A4E1E);
  static const map = Color(0xFFE9E5DE);
  static const stripeA = Color(0xFFF1E8DF);
  static const stripeB = Color(0xFFEDE2D8);
  static const white = Color(0xFFFFFFFF);
}
