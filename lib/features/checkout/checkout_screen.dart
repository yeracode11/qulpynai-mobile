import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/visuals.dart';
import '../../data/providers.dart';
import '../cart/cart_controller.dart';
import '../cart/cart_screen.dart';

/// 1k — checkout: delivery/pickup, address, time slot, recipient.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _day = 0;
  int _slot = 0;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mode = ref.watch(fulfilmentProvider);
    final pickup = mode == FulfilmentMode.pickup;
    final profile = ref.watch(profileProvider).value;
    final cart = ref.watch(cartProvider);
    final now = DateTime.now();
    final dayAfter = now.add(const Duration(days: 2));
    final days = [l10n.today, l10n.tomorrow, '${dayAfter.day.toString().padLeft(2, '0')}.${dayAfter.month.toString().padLeft(2, '0')}'];
    final slots = [l10n.asap, '14:00–15:00', '15:00–16:00'];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: l10n.checkout),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  Segmented(
                    value: pickup ? FulfilmentMode.pickup : FulfilmentMode.delivery,
                    onChanged: (m) => ref.read(fulfilmentProvider.notifier).set(m),
                    options: [(FulfilmentMode.delivery, l10n.delivery), (FulfilmentMode.pickup, l10n.pickup)],
                  ),
                  const SizedBox(height: 12),
                  Material(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(22),
                    elevation: 6,
                    shadowColor: const Color(0x401F1A17),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () => pickup ? context.go('/stores') : context.push('/address'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          spacing: 12,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(color: AppColors.redSoft, shape: BoxShape.circle),
                              child: Icon(pickup ? Icons.storefront_outlined : Icons.place_outlined, size: 20, color: AppColors.red),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  Text(
                                    pickup ? 'Qulpynai · Абая' : (profile == null ? '…' : context.tr(profile.address.street)),
                                    style: AppText.ui(15, weight: FontWeight.w700),
                                  ),
                                  Text(
                                    pickup
                                        ? l10n.pickupSub
                                        : profile == null
                                        ? ''
                                        : l10n.apartment(profile.address.apartment, profile.address.floor),
                                    style: AppText.ui(12, weight: FontWeight.w500, color: AppColors.muted),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  QCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Text(l10n.whenDeliver, style: AppText.ui(15, weight: FontWeight.w700)),
                        Wrap(
                          spacing: 8,
                          children: [
                            for (var i = 0; i < days.length; i++)
                              QChip(
                                label: days[i],
                                selected: i == _day,
                                color: AppColors.bg,
                                selectedColor: AppColors.redSoft,
                                selectedForeground: AppColors.redDark,
                                onTap: () => setState(() => _day = i),
                              ),
                          ],
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            for (var i = 0; i < slots.length; i++)
                              Expanded(
                                child: Semantics(
                                  selected: i == _slot,
                                  button: true,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _slot = i),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 150),
                                      height: 44,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: i == _slot ? AppColors.red : AppColors.line, width: i == _slot ? 2 : 1.5),
                                      ),
                                      child: Text(
                                        slots[i],
                                        textAlign: TextAlign.center,
                                        style: i == 0
                                            ? AppText.ui(
                                                12,
                                                weight: FontWeight.w700,
                                                color: i == _slot ? AppColors.redDark : AppColors.ink,
                                                height: 1.15,
                                              )
                                            : AppText.num(13, color: i == _slot ? AppColors.redDark : AppColors.ink),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  QCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(l10n.recipient, style: AppText.ui(15, weight: FontWeight.w700)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(profile == null ? '' : context.tr(profile.name), style: AppText.ui(14)),
                            Text(profile == null ? '' : formatPhone(profile.phone), style: AppText.num(14, weight: FontWeight.w600)),
                          ],
                        ),
                        TextField(
                          controller: _comment,
                          style: AppText.ui(13, weight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: l10n.commentHint,
                            hintStyle: AppText.ui(13, weight: FontWeight.w500, color: AppColors.muted),
                            filled: true,
                            fillColor: AppColors.bg,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            BottomSheetPanel(
              spacing: 12,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(l10n.total, style: AppText.ui(15)),
                    Text(formatTenge(cart.total), style: AppText.num(22)),
                  ],
                ),
                PillButton(label: l10n.toPay, onPressed: cart.isEmpty ? null : () => context.push('/payment')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
