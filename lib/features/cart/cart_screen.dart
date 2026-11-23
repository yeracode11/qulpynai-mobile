import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/visuals.dart';
import '../../data/providers.dart';
import 'cart_controller.dart';

/// 1j — cart with upsell and totals.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cart = ref.watch(cartProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 20, 0),
              child: Row(
                spacing: 4,
                children: [
                  const BackCircleButton(background: Colors.transparent),
                  Expanded(child: Text(l10n.cart, style: AppText.serif(30))),
                  if (!cart.isEmpty)
                    TextButton(
                      onPressed: () => ref.read(cartProvider.notifier).clear(),
                      child: Text(l10n.clear, style: AppText.ui(14, color: AppColors.muted)),
                    ),
                ],
              ),
            ),
            Expanded(child: cart.isEmpty ? const _Empty() : _Lines(cart: cart)),
            if (!cart.isEmpty) _Totals(cart: cart),
          ],
        ),
      ),
    );
  }
}

class _Lines extends ConsumerWidget {
  const _Lines({required this.cart});

  final CartState cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ctrl = ref.read(cartProvider.notifier);
    final upsell = ref.watch(upsellProvider).value ?? const [];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      children: [
        for (final line in cart.lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: QCard(
              padding: const EdgeInsets.all(10),
              child: Row(
                spacing: 12,
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(18)),
                    child: ProductPhoto(asset: line.product.image, size: 72, radius: 18),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Text(context.tr(line.product.name), style: AppText.ui(14, height: 1.2)),
                        Text(
                          [formatWeight(line.weightGrams), if (line.note?.isNotEmpty ?? false) '«${line.note}»'].join(' · '),
                          style: AppText.ui(12, weight: FontWeight.w500, color: AppColors.muted),
                        ),
                        Text(formatTenge(line.total), style: AppText.num(15)),
                      ],
                    ),
                  ),
                  QtyStepper(
                    vertical: true,
                    buttonSize: 30,
                    qty: line.qty,
                    incrementLabel: l10n.increase,
                    decrementLabel: l10n.decrease,
                    onIncrement: () => ctrl.increment(line.key),
                    onDecrement: () => ctrl.decrement(line.key),
                  ),
                ],
              ),
            ),
          ),
        if (upsell.isNotEmpty)
          QCard(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text(l10n.upsell, style: AppText.ui(15, weight: FontWeight.w700)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    for (final p in upsell)
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: '${l10n.addToCart}: ${context.tr(p.name)}',
                          child: GestureDetector(
                            onTap: () => ctrl.add(p),
                            child: Column(
                              spacing: 6,
                              children: [
                                SizedBox.square(
                                  dimension: 64,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      const Positioned.fill(child: StripedPlaceholder(shape: BoxShape.circle, stripe: 8)),
                                      Positioned(
                                        right: -4,
                                        bottom: -4,
                                        child: Container(
                                          width: 26,
                                          height: 26,
                                          decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                                          child: const Icon(Icons.add_rounded, size: 18, color: AppColors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(context.tr(p.name), textAlign: TextAlign.center, style: AppText.ui(11, height: 1.2)),
                                Text(formatTenge(p.price), style: AppText.num(12, color: AppColors.muted)),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.cart});

  final CartState cart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BottomSheetPanel(
      children: [
        _row(l10n.subtotal, Text(formatTenge(cart.subtotal), style: AppText.num(14, weight: FontWeight.w600))),
        _row(
          l10n.delivery,
          cart.deliveryFee == 0
              ? Text(
                  l10n.free,
                  style: AppText.ui(14, weight: FontWeight.w700, color: AppColors.green),
                )
              : Text(formatTenge(cart.deliveryFee), style: AppText.num(14, weight: FontWeight.w600)),
        ),
        const SizedBox(height: 6),
        PillButton(label: l10n.checkoutCta, trailing: formatTenge(cart.total), onPressed: () => context.push('/checkout')),
      ],
    );
  }

  Widget _row(String label, Widget value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: AppText.ui(14, weight: FontWeight.w500, color: AppColors.inkSoft),
      ),
      value,
    ],
  );
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            const QLogo(height: 56),
            Text(l10n.cartEmpty, style: AppText.serif(24)),
            Text(
              l10n.cartEmptyText,
              textAlign: TextAlign.center,
              style: AppText.ui(14, weight: FontWeight.w500, color: AppColors.inkSoft),
            ),
            const SizedBox(height: 8),
            PillButton(
              label: l10n.toMenu,
              onPressed: () {
                context.pop();
                context.go('/menu');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// White panel pinned to the bottom with rounded top corners.
class BottomSheetPanel extends StatelessWidget {
  const BottomSheetPanel({super.key, required this.children, this.spacing = 10});

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Color(0x0F1F1A17), blurRadius: 24, offset: Offset(0, -8))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, spacing: spacing, children: children),
      ),
    );
  }
}
