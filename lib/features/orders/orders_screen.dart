import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/tab_bar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/visuals.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// 1o — my orders with live tracking of the active one.
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  bool _history = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AsyncView(
          value: ref.watch(ordersProvider),
          builder: (orders) {
            final active = orders.where((o) => o.isActive).toList();
            final past = orders.where((o) => !o.isActive).toList();
            return ListView(
              padding: EdgeInsets.fromLTRB(16, 4, 16, tabBarClearance(context)),
              children: [
                ScreenHeader(title: l10n.orders, horizontalPadding: 0),
                const SizedBox(height: 16),
                Segmented(
                  height: 44,
                  value: _history,
                  onChanged: (v) => setState(() => _history = v),
                  options: [(false, '${l10n.active} · ${active.length}'), (true, l10n.history)],
                ),
                const SizedBox(height: 14),
                if (!_history) ...[
                  if (active.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(l10n.noActiveOrders, style: AppText.ui(14, color: AppColors.muted)),
                      ),
                    ),
                  for (final o in active) _ActiveOrderCard(order: o),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 4, bottom: 10),
                    child: Text(l10n.history, style: AppText.ui(16, weight: FontWeight.w700)),
                  ),
                ],
                for (final o in past)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _PastOrderTile(order: o),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [l10n.stAccepted, l10n.stBaking, l10n.stWay, l10n.stDone];
    final current = order.status.index;
    return QCard(
      radius: 26,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('№ ${order.number}', style: AppText.num(16)),
              Text(formatTenge(order.total), style: AppText.num(16)),
            ],
          ),
          if (order.etaMinutes != null)
            Text(l10n.courierEta('${order.etaMinutes}'), style: AppText.heading(20, color: AppColors.tealDark, height: 1.2)),
          Column(
            spacing: 8,
            children: [
              Row(
                spacing: 4,
                children: [
                  for (var i = 0; i < steps.length; i++)
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: i < current ? 1 : (i == current ? .55 : 0),
                          minHeight: 6,
                          color: AppColors.teal,
                          backgroundColor: AppColors.tealSoft,
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                spacing: 4,
                children: [
                  for (var i = 0; i < steps.length; i++)
                    Expanded(
                      child: Text(
                        steps[i],
                        style: AppText.ui(
                          11,
                          weight: i == current ? FontWeight.w700 : FontWeight.w600,
                          color: i == current ? AppColors.ink : AppColors.muted,
                          height: 1.2,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const Divider(height: 1, color: AppColors.line),
          Row(
            spacing: 8,
            children: [
              const ProductPhoto(asset: 'assets/images/product1.png', size: 40),
              const ProductPhoto(asset: 'assets/images/product1.png', size: 40),
              if (order.itemsCount > 2)
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: AppColors.bg, shape: BoxShape.circle),
                  child: Text('+${order.itemsCount - 2}', style: AppText.num(12)),
                ),
              const Spacer(),
              CircleIconButton(
                icon: Icons.call_outlined,
                size: 40,
                background: AppColors.tealSoft,
                foreground: AppColors.tealDark,
                tooltip: l10n.call,
                onPressed: () => showStub(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PastOrderTile extends StatelessWidget {
  const _PastOrderTile({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final d = order.date;
    final date = '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
    return QCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                Text('№ ${order.number} · ${formatTenge(order.total)}', style: AppText.num(14)),
                Text(
                  date,
                  style: AppText.ui(12, weight: FontWeight.w500, color: AppColors.muted),
                ),
              ],
            ),
          ),
          QChip(
            label: l10n.repeat,
            selected: true,
            selectedColor: AppColors.redSoft,
            selectedForeground: AppColors.redDark,
            onTap: () => showStub(context),
          ),
        ],
      ),
    );
  }
}
