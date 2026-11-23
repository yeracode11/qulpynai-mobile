import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../core/utils/l10n.dart';
import '../features/cart/cart_controller.dart';

/// Floating pill tab bar with a separate red cart button (design QTabBar).
class QTabBar extends ConsumerWidget {
  const QTabBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final count = ref.watch(cartProvider.select((c) => c.count));
    final tabs = [
      (Icons.home_outlined, l10n.tabHome),
      (Icons.grid_view_rounded, l10n.tabMenu),
      (Icons.place_outlined, l10n.tabStores),
      (Icons.person_outline_rounded, l10n.tabProfile),
    ];
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(34),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    height: 68,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(color: const Color(0xEBFFFFFF), borderRadius: BorderRadius.circular(34)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0; i < tabs.length; i++)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1),
                              child: _TabItem(icon: tabs[i].$1, label: tabs[i].$2, active: i == currentIndex, onTap: () => onTap(i)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _CartButton(count: count),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.icon, required this.label, required this.active, required this.onTap});

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.red : AppColors.muted;
    return Semantics(
      selected: active,
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 56,
            decoration: BoxDecoration(color: active ? AppColors.redSoft : Colors.transparent, borderRadius: BorderRadius.circular(28)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4,
              children: [
                Icon(icon, size: 22, color: color),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: AppText.ui(10, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.cartButton('$count'),
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: () => context.push('/cart'),
          child: Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x59E42F30), blurRadius: 24, offset: Offset(0, 8))],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 26, color: AppColors.white),
                if (count > 0)
                  PositionedDirectional(
                    top: 6,
                    end: 6,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 20),
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10)),
                      child: Text('$count', style: AppText.num(11, color: AppColors.red)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom padding a tab screen needs so content clears the floating bar.
double tabBarClearance(BuildContext context) => 120 + MediaQuery.paddingOf(context).bottom;
