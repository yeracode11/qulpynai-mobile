import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Rounded filter chip: red when selected, white otherwise.
class QChip extends StatelessWidget {
  const QChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.height = 40,
    this.selectedColor = AppColors.red,
    this.selectedForeground = AppColors.white,
    this.color = AppColors.white,
    this.numeric = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double height;
  final Color selectedColor;
  final Color selectedForeground;
  final Color color;
  final bool numeric;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? selectedForeground : AppColors.ink;
    final style = numeric ? AppText.num(13, color: fg) : AppText.ui(13, weight: selected ? FontWeight.w700 : FontWeight.w600, color: fg);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? selectedColor : color,
        borderRadius: BorderRadius.circular(height / 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(height / 2),
          onTap: onTap,
          child: Container(
            height: height,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Center(widthFactor: 1, child: Text(label, style: style)),
          ),
        ),
      ),
    );
  }
}

/// Horizontally scrolling row of single-select chips.
class ChipRow extends StatelessWidget {
  const ChipRow({super.key, required this.labels, required this.selected, required this.onSelected, this.height = 36});

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) => QChip(label: labels[i], selected: i == selected, onTap: () => onSelected(i), height: height),
      ),
    );
  }
}

enum SegmentedStyle {
  /// White thumb on a light-grey track (home header).
  light,

  /// Dark thumb on a white track (checkout, orders).
  dark,
}

/// Pill-shaped segmented control.
class Segmented<T> extends StatelessWidget {
  const Segmented({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.style = SegmentedStyle.dark,
    this.height = 48,
    this.track,
  });

  final List<(T, String)> options;
  final T value;
  final ValueChanged<T> onChanged;
  final SegmentedStyle style;
  final double height;
  final Color? track;

  @override
  Widget build(BuildContext context) {
    final dark = style == SegmentedStyle.dark;
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: track ?? (dark ? AppColors.white : AppColors.bg), borderRadius: BorderRadius.circular(height / 2)),
      child: Row(
        spacing: 4,
        children: [
          for (final (v, label) in options)
            Expanded(
              child: Semantics(
                selected: v == value,
                button: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(v),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: v == value ? (dark ? AppColors.ink : AppColors.white) : Colors.transparent,
                      borderRadius: BorderRadius.circular((height - 8) / 2),
                      boxShadow: v == value && !dark
                          ? const [BoxShadow(color: Color(0x141F1A17), blurRadius: 6, offset: Offset(0, 2))]
                          : null,
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.ui(
                        height > 44 ? 14 : 13,
                        weight: v == value ? FontWeight.w700 : FontWeight.w600,
                        color: v == value ? (dark ? AppColors.white : AppColors.ink) : AppColors.muted,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
