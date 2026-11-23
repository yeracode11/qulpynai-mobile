import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Typography. One family — Onest — for headings, UI and numbers: it has
/// full Kazakh Cyrillic and the ₸ sign, and lining tabular figures for prices.
///
/// Prefer the named scale ([display] … [caption]). The [heading], [ui] and
/// [num] helpers are for one-off sizes; anything below 12 px is raised to 12
/// so no text in the app falls under the readable minimum.
abstract final class AppText {
  static const family = 'Onest';
  static const minSize = 12.0;
  static const _tabular = [FontFeature.tabularFigures()];

  // ── Named scale ───────────────────────────────────────────────
  /// 30/36 — large titles of tab roots and onboarding.
  static TextStyle get display => heading(30, height: 1.2);

  /// 22/28 — screen titles.
  static TextStyle get title => heading(22, height: 1.27);

  /// 18/24 — section headers, card titles.
  static TextStyle get headline => heading(18, height: 1.33);

  /// 16/22 semibold — list item titles, button labels.
  static TextStyle get titleSmall => ui(16, height: 1.375);

  /// 15/22 regular — body text.
  static TextStyle get body => ui(15, weight: FontWeight.w400, color: AppColors.inkSoft, height: 1.47);

  /// 13/18 — secondary text.
  static TextStyle get bodySmall => ui(13, weight: FontWeight.w500, color: AppColors.muted, height: 1.38);

  /// 12/16 — captions, metadata.
  static TextStyle get caption => ui(12, weight: FontWeight.w500, color: AppColors.muted, height: 1.33);

  // ── Helpers ───────────────────────────────────────────────────
  static TextStyle heading(double size, {FontWeight weight = FontWeight.w700, Color color = AppColors.ink, double? height}) => TextStyle(
    fontFamily: family,
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height ?? 1.2,
    letterSpacing: size >= 20 ? -0.5 : -0.2,
  );

  static TextStyle ui(double size, {FontWeight weight = FontWeight.w600, Color color = AppColors.ink, double? height}) =>
      TextStyle(fontFamily: family, fontSize: size < minSize ? minSize : size, fontWeight: weight, color: color, height: height);

  static TextStyle num(double size, {FontWeight weight = FontWeight.w700, Color color = AppColors.ink, double? height}) => TextStyle(
    fontFamily: family,
    fontSize: size < minSize ? minSize : size,
    fontWeight: weight,
    color: color,
    height: height,
    fontFeatures: _tabular,
    letterSpacing: size >= 20 ? -0.5 : 0,
  );
}
