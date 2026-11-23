import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// Glossy, saturated surface treatment: vertical fill gradients, a top
/// sheen highlight and colored glows. Mid-tone of every fill equals the
/// base color, so text contrast measured on the base color still holds.
abstract final class AppGloss {
  /// Top-lit vertical fill around [c].
  static LinearGradient fill(Color c) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color.lerp(c, AppColors.white, .12)!, c, Color.lerp(c, const Color(0xFF000000), .14)!],
    stops: const [0, .5, 1],
  );

  /// Soft pastel fill for tiles: lighter at the top, richer at the bottom.
  static LinearGradient tint(Color c) =>
      LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color.lerp(c, AppColors.white, .55)!, c]);

  /// White highlight over the top half, the "glass" reflection.
  static const sheen = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x47FFFFFF), Color(0x14FFFFFF), Color(0x00FFFFFF)],
    stops: [0, .45, .55],
  );

  /// Colored glow under a filled control.
  static List<BoxShadow> glow(Color c) => [
    BoxShadow(color: c.withValues(alpha: .38), blurRadius: 18, offset: const Offset(0, 8)),
    BoxShadow(color: c.withValues(alpha: .22), blurRadius: 4, offset: const Offset(0, 2)),
  ];

  /// Lifted card on the warm background.
  static const card = [
    BoxShadow(color: Color(0x141F1A17), blurRadius: 22, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0A1F1A17), blurRadius: 3, offset: Offset(0, 1)),
  ];
}

/// A tappable glossy surface: gradient fill, sheen, glow and ink ripple.
class GlossSurface extends StatelessWidget {
  const GlossSurface({super.key, required this.color, required this.shape, required this.child, this.onTap, this.glow = true});

  final Color color;
  final ShapeBorder shape;
  final Widget child;
  final VoidCallback? onTap;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final base = enabled ? color : color.withValues(alpha: .5);
    return DecoratedBox(
      decoration: ShapeDecoration(shape: shape, gradient: AppGloss.fill(base), shadows: enabled && glow ? AppGloss.glow(color) : null),
      child: Material(
        type: MaterialType.transparency,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: ShapeDecoration(shape: shape, gradient: AppGloss.sheen),
                ),
              ),
            ),
            InkWell(onTap: onTap, customBorder: shape, child: child),
          ],
        ),
      ),
    );
  }
}
