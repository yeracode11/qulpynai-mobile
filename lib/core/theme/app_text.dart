import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Three families from the design:
/// * Lora — headings ([serif])
/// * Raleway — UI and body text ([ui])
/// * Gilroy — prices and numbers ([num]); the ₸ glyph comes from GilroyTenge.
abstract final class AppText {
  static const _numFallback = ['GilroyTenge', 'Raleway'];

  static TextStyle serif(double size, {FontWeight weight = FontWeight.w700, Color color = AppColors.ink, double? height}) =>
      TextStyle(fontFamily: 'Lora', fontSize: size, fontWeight: weight, color: color, height: height);

  static TextStyle ui(double size, {FontWeight weight = FontWeight.w600, Color color = AppColors.ink, double? height}) =>
      TextStyle(fontFamily: 'Raleway', fontSize: size, fontWeight: weight, color: color, height: height);

  static TextStyle num(double size, {FontWeight weight = FontWeight.w700, Color color = AppColors.ink, double? height}) =>
      TextStyle(fontFamily: 'Gilroy', fontFamilyFallback: _numFallback, fontSize: size, fontWeight: weight, color: color, height: height);
}
