import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/visuals.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/models.dart';

/// Which pushes the user wants. Local until the backend stores preferences.
class NotificationPrefs extends Notifier<({bool orders, bool promo})> {
  @override
  ({bool orders, bool promo}) build() => (orders: true, promo: false);

  void setOrders(bool v) => state = (orders: v, promo: state.promo);
  void setPromo(bool v) => state = (orders: state.orders, promo: v);
}

final notificationPrefsProvider = NotifierProvider<NotificationPrefs, ({bool orders, bool promo})>(NotificationPrefs.new);

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final prefs = ref.watch(notificationPrefsProvider);
    final ctrl = ref.read(notificationPrefsProvider.notifier);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: l10n.notifications),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.paddingOf(context).bottom),
                children: [
                  Text(l10n.notifSettings, style: AppText.headline),
                  const SizedBox(height: 10),
                  QCard(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        _Toggle(title: l10n.notifOrders, subtitle: l10n.notifOrdersHint, value: prefs.orders, onChanged: ctrl.setOrders),
                        const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                        _Toggle(title: l10n.notifPromo, subtitle: l10n.notifPromoHint, value: prefs.promo, onChanged: ctrl.setPromo),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(l10n.notifRecent, style: AppText.headline),
                  const SizedBox(height: 10),
                  for (final n in MockData.notifications) Padding(padding: const EdgeInsets.only(bottom: 10), child: _NotificationTile(n)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.title, required this.subtitle, required this.value, required this.onChanged});

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.white,
      activeTrackColor: AppColors.tealDeep,
      title: Text(title, style: AppText.titleSmall),
      subtitle: Text(subtitle, style: AppText.bodySmall),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile(this.n);

  final AppNotification n;

  @override
  Widget build(BuildContext context) {
    final t = n.time;
    String two(int v) => v.toString().padLeft(2, '0');
    final when = '${two(t.day)}.${two(t.month)} · ${two(t.hour)}:${two(t.minute)}';
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: n.link == null ? null : () => context.go(n.link!),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: n.isOrder ? AppColors.tealSoft : AppColors.redSoft, shape: BoxShape.circle),
                child: Icon(
                  n.isOrder ? Icons.local_shipping_outlined : Icons.local_offer_outlined,
                  size: 20,
                  color: n.isOrder ? AppColors.tealDark : AppColors.redDark,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(context.tr(n.title), style: AppText.titleSmall),
                    Text(context.tr(n.body), style: AppText.bodySmall),
                    Text(when, style: AppText.caption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
