import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_gloss.dart';
import '../theme/app_text.dart';

/// The strawberry logo. [color] tints it solid (used on red backgrounds).
class QLogo extends StatelessWidget {
  const QLogo({super.key, this.height = 38, this.color, this.semanticLabel});

  final double height;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      height: height,
      width: height * 30 / 38,
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
      colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}

/// Round product photo.
class ProductPhoto extends StatelessWidget {
  const ProductPhoto({super.key, required this.asset, required this.size, this.radius});

  final String asset;
  final double size;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? size / 2),
      child: Image.asset(asset, width: size, height: size, fit: BoxFit.cover, cacheWidth: (size * 3).round(), excludeFromSemantics: true),
    );
  }
}

/// Diagonal-striped stand-in for photos we don't have yet.
class StripedPlaceholder extends StatelessWidget {
  const StripedPlaceholder({
    super.key,
    this.label,
    this.a = AppColors.stripeA,
    this.b = AppColors.stripeB,
    this.radius = BorderRadius.zero,
    this.stripe = 12,
    this.labelColor = AppColors.muted,
    this.shape = BoxShape.rectangle,
  });

  final String? label;
  final Color a;
  final Color b;
  final BorderRadius radius;
  final double stripe;
  final Color labelColor;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final clip = shape == BoxShape.circle
        ? ClipOval(
            child: CustomPaint(painter: _StripePainter(a, b, stripe), child: const SizedBox.expand()),
          )
        : ClipRRect(
            borderRadius: radius,
            child: CustomPaint(painter: _StripePainter(a, b, stripe), child: const SizedBox.expand()),
          );
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(child: clip),
        if (label != null)
          Text(
            label!,
            style: TextStyle(fontFamily: 'Onest', fontSize: 12, fontWeight: FontWeight.w500, color: labelColor),
          ),
      ],
    );
  }
}

class _StripePainter extends CustomPainter {
  _StripePainter(this.a, this.b, this.stripe);

  final Color a;
  final Color b;
  final double stripe;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = b);
    final paint = Paint()..color = a;
    final step = stripe * 2;
    // 135° stripes: parallelograms running from top-left to bottom-right.
    for (double x = -size.height; x < size.width + size.height; x += step) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + stripe * 1.414, 0)
        ..lineTo(x + stripe * 1.414 + size.height, size.height)
        ..lineTo(x + size.height, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => old.a != a || old.b != b || old.stripe != stripe;
}

/// Grid-paper map stand-in until 2GIS / Yandex Maps is wired in.
class MapPlaceholder extends StatelessWidget {
  const MapPlaceholder({super.key, this.caption});

  final String? caption;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
      child: caption == null
          ? null
          : Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 12, top: 64),
                child: Text(
                  caption!,
                  style: const TextStyle(fontFamily: 'Onest', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.muted),
                ),
              ),
            ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.map);
    final line = Paint()
      ..color = const Color(0xB3FFFFFF)
      ..strokeWidth = 2;
    for (double x = 0; x < size.width; x += 64) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 0; y < size.height; y += 64) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

/// Section title + optional "All" link.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(header: true, child: Text(title, style: AppText.headline)),
        ),
        if (action != null) TextLink(label: action!, onPressed: onAction),
      ],
    );
  }
}

/// Text-only action with a 44 px tall touch area.
class TextLink extends StatelessWidget {
  const TextLink({super.key, required this.label, required this.onPressed, this.color = AppColors.red});

  final String label;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        minimumSize: const Size(44, 44),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: AppText.ui(14),
        shape: const StadiumBorder(),
      ),
      child: Text(label),
    );
  }
}

/// Standard top bar for pushed screens: back button, title, optional actions.
/// Large variant is for tab roots (title only, 30 px).
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = true,
    this.backBackground = AppColors.white,
    this.actions = const [],
    this.large = false,
    this.centered = false,
    this.horizontalPadding = 16,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final Color backBackground;
  final List<Widget> actions;
  final bool large;
  final bool centered;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final titleWidget = Column(
      crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: large ? AppText.display : AppText.title,
          ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(subtitle!, style: AppText.caption),
          ),
      ],
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, large ? 4 : 8),
      child: Row(
        spacing: 12,
        children: [
          if (showBack) _BackButton(background: backBackground),
          Expanded(child: titleWidget),
          ...actions,
          if (centered && showBack && actions.isEmpty) const SizedBox(width: 44),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.background});

  final Color background;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: MaterialLocalizations.of(context).backButtonTooltip,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => Navigator.of(context).maybePop(),
          child: const SizedBox.square(dimension: 44, child: Icon(Icons.arrow_back_rounded, size: 22, color: AppColors.ink)),
        ),
      ),
    );
  }
}

/// White rounded card used everywhere on the warm background.
class QCard extends StatelessWidget {
  const QCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 22,
    this.color = AppColors.white,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: color == AppColors.white ? AppGloss.panel : AppGloss.tint(color),
        borderRadius: BorderRadius.circular(radius),
        border: border ?? Border.all(color: AppColors.white, width: 1.2),
        boxShadow: AppGloss.card,
      ),
      child: child,
    );
  }
}

/// Radio dot from the payment screen.
class RadioDot extends StatelessWidget {
  const RadioDot({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? AppColors.red : AppColors.outline, width: selected ? 6 : 2),
      ),
    );
  }
}

/// Square checkbox from the custom cake screen.
class QCheckbox extends StatelessWidget {
  const QCheckbox({super.key, required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: checked ? AppColors.red : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        border: checked ? null : Border.all(color: AppColors.outline, width: 1.5),
      ),
      child: checked ? const Icon(Icons.check_rounded, size: 16, color: AppColors.white) : null,
    );
  }
}
