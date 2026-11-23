import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/visuals.dart';
import '../../data/mock/mock_data.dart';
import '../../data/providers.dart';
import '../cart/cart_controller.dart';

enum _Method { kaspi, card }

/// 1l — payment: Kaspi / card, bonus write-off. No real payment is made.
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  _Method _method = _Method.kaspi;
  bool _useBonus = true;
  bool _paying = false;

  Future<void> _pay(int amount) async {
    setState(() => _paying = true);
    await ref.read(ordersRepositoryProvider).placeOrder(total: amount);
    if (!mounted) return;
    ref.read(cartProvider.notifier).clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.orderPlaced)));
    context.go('/profile/orders');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cart = ref.watch(cartProvider);
    final bonus = ref.watch(profileProvider).value?.bonus ?? 0;
    final writeOff = _useBonus ? MockData.bonusWriteOff : 0;
    final amount = (cart.total - writeOff).clamp(0, 1 << 31);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                spacing: 12,
                children: [
                  const BackCircleButton(),
                  Text(l10n.payment, style: AppText.serif(22)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(28)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text(l10n.total, style: AppText.ui(13, color: const Color(0xB3FFFFFF))),
                        Text(formatTenge(amount), style: AppText.num(38, color: AppColors.white)),
                        if (writeOff > 0)
                          Text(
                            formatTenge(cart.total),
                            style: AppText.num(
                              12,
                              weight: FontWeight.w600,
                              color: const Color(0xB3FFFFFF),
                            ).copyWith(decoration: TextDecoration.lineThrough, decorationColor: const Color(0xB3FFFFFF)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(l10n.payMethod, style: AppText.ui(15, weight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 6),
                  _MethodTile(
                    selected: _method == _Method.kaspi,
                    onTap: () => setState(() => _method = _Method.kaspi),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/images/kaspi_button_4.jpg',
                        width: 72,
                        height: 24,
                        fit: BoxFit.cover,
                        semanticLabel: 'Kaspi',
                      ),
                    ),
                    title: 'Kaspi.kz',
                    subtitle: l10n.kaspiSub,
                  ),
                  const SizedBox(height: 10),
                  _MethodTile(
                    selected: _method == _Method.card,
                    onTap: () => setState(() => _method = _Method.card),
                    leading: Container(
                      width: 72,
                      height: 24,
                      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.credit_card_rounded, size: 18),
                    ),
                    title: l10n.card,
                    subtitle: l10n.cardSub,
                  ),
                  const SizedBox(height: 10),
                  QCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      spacing: 12,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: AppColors.greenSoft, shape: BoxShape.circle),
                          child: Text('B', style: AppText.num(14, color: AppColors.greenDark)),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(l10n.useBonus, style: AppText.ui(15, weight: FontWeight.w700)),
                              Text(
                                '− ${formatTenge(MockData.bonusWriteOff)} · ${formatThousands(bonus)}',
                                style: AppText.num(12, weight: FontWeight.w600, color: AppColors.muted),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _useBonus,
                          activeTrackColor: AppColors.green,
                          activeThumbColor: AppColors.white,
                          onChanged: (v) => setState(() => _useBonus = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                spacing: 12,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.muted),
                      Text(
                        l10n.secure,
                        style: AppText.ui(12, weight: FontWeight.w500, color: AppColors.muted),
                      ),
                    ],
                  ),
                  PillButton(
                    label: l10n.pay,
                    trailing: formatTenge(amount),
                    loading: _paying,
                    onPressed: cart.isEmpty ? null : () => _pay(amount),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({required this.selected, required this.onTap, required this.leading, required this.title, required this.subtitle});

  final bool selected;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: selected ? AppColors.red : Colors.transparent, width: 2),
          ),
          child: Row(
            spacing: 12,
            children: [
              leading,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(title, style: AppText.ui(15, weight: FontWeight.w700)),
                    Text(
                      subtitle,
                      style: AppText.ui(12, weight: FontWeight.w500, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              RadioDot(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}
