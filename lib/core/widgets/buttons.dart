import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Round 44px icon button used for back / close / share / search.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.background = AppColors.white,
    this.foreground = AppColors.ink,
    this.size = 44,
    this.shadow = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color background;
  final Color foreground;
  final double size;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        elevation: 0,
        shadowColor: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: shadow ? const [BoxShadow(color: Color(0x1A1F1A17), blurRadius: 12, offset: Offset(0, 4))] : null,
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox.square(
              dimension: size,
              child: Icon(icon, size: 20, color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}

/// Back button that pops the current route.
class BackCircleButton extends StatelessWidget {
  const BackCircleButton({super.key, this.background = AppColors.white, this.icon = Icons.chevron_left_rounded});

  final Color background;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      icon: icon,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      background: background,
      onPressed: () => Navigator.of(context).maybePop(),
    );
  }
}

/// Full-width 56px pill: the main call to action on every screen.
/// Optional [trailing] (usually a price) sits on the right.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailing,
    this.color = AppColors.red,
    this.foreground = AppColors.white,
    this.height = 56,
    this.loading = false,
    this.shadow = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? trailing;
  final Color color;
  final Color foreground;
  final double height;
  final bool loading;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppText.ui(16, weight: FontWeight.w700, color: foreground);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: shadow ? [BoxShadow(color: color.withValues(alpha: .3), blurRadius: 24, offset: const Offset(0, 10))] : null,
      ),
      child: Material(
        color: onPressed == null ? color.withValues(alpha: .5) : color,
        borderRadius: BorderRadius.circular(height / 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(height / 2),
          onTap: loading ? null : onPressed,
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: loading
                  ? Center(
                      child: SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: foreground)),
                    )
                  : Row(
                      mainAxisAlignment: trailing == null ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(label, style: labelStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        if (trailing != null) Text(trailing!, style: AppText.num(17, color: foreground)),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small red "+" button on product cards.
class AddRoundButton extends StatelessWidget {
  const AddRoundButton({super.key, required this.onPressed, required this.tooltip, this.size = 36});

  final VoidCallback onPressed;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleIconButton(
      icon: Icons.add_rounded,
      tooltip: tooltip,
      onPressed: onPressed,
      background: AppColors.red,
      foreground: AppColors.white,
      size: size,
    );
  }
}

/// Vertical or horizontal − qty + stepper.
class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.qty,
    required this.onIncrement,
    required this.onDecrement,
    required this.incrementLabel,
    required this.decrementLabel,
    this.vertical = false,
    this.buttonSize = 40,
  });

  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String incrementLabel;
  final String decrementLabel;
  final bool vertical;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    Widget btn(String glyph, VoidCallback onTap, String label) => Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: Material(
          color: AppColors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox.square(
              dimension: buttonSize,
              child: Center(child: Text(glyph, style: AppText.num(buttonSize > 34 ? 20 : 16))),
            ),
          ),
        ),
      ),
    );
    final count = SizedBox(
      width: vertical ? null : 28,
      height: vertical ? 22 : null,
      child: Center(child: Text('$qty', style: AppText.num(vertical ? 14 : 17))),
    );
    final children = vertical
        ? [btn('+', onIncrement, incrementLabel), count, btn('−', onDecrement, decrementLabel)]
        : [btn('−', onDecrement, decrementLabel), count, btn('+', onIncrement, incrementLabel)];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(28)),
      child: vertical
          ? Column(mainAxisSize: MainAxisSize.min, spacing: 2, children: children)
          : Row(mainAxisSize: MainAxisSize.min, spacing: 4, children: children),
    );
  }
}
