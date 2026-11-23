import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/tab_bar.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gloss.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/lang_switch.dart';
import '../../core/widgets/visuals.dart';
import '../../data/providers.dart';

/// 1p — profile, bonus card, settings and language.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final rows = [
      (Icons.shopping_bag_outlined, l10n.orders, () => context.go('/profile/orders')),
      (Icons.place_outlined, l10n.addresses, () => context.push('/address')),
      (Icons.favorite_border_rounded, l10n.favorites, () => showStub(context)),
      (Icons.notifications_none_rounded, l10n.notifications, () => showStub(context)),
      (Icons.chat_bubble_outline_rounded, l10n.support, () => showStub(context)),
    ];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AsyncView(
          value: ref.watch(profileProvider),
          builder: (user) {
            final name = context.tr(user.name);
            return ListView(
              padding: EdgeInsets.fromLTRB(16, 10, 16, tabBarClearance(context)),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    spacing: 14,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.teal,
                        child: Text(name.characters.first, style: AppText.heading(24, color: AppColors.white)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Text(name, style: AppText.heading(24)),
                          Text(
                            formatPhone(user.phone),
                            style: AppText.num(13, weight: FontWeight.w600, color: AppColors.muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    gradient: AppGloss.fill(AppColors.red),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: AppGloss.glow(AppColors.red),
                  ),
                  child: Stack(
                    children: [
                      const PositionedDirectional(
                        end: -20,
                        top: -16,
                        child: Opacity(opacity: .16, child: QLogo(height: 190, color: AppColors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(l10n.bonusCard, style: AppText.ui(13, color: const Color(0xD9FFFFFF))),
                            Text(formatThousands(user.bonus), style: AppText.num(40, color: AppColors.white)),
                            SizedBox(
                              width: 240,
                              child: Text(
                                l10n.bonusHint,
                                style: AppText.ui(12, weight: FontWeight.w500, color: const Color(0xE6FFFFFF), height: 1.33),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                QCard(
                  radius: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    children: [
                      for (var i = 0; i < rows.length; i++)
                        InkWell(
                          onTap: rows[i].$3,
                          child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                              border: i < rows.length - 1 ? const Border(bottom: BorderSide(color: AppColors.divider)) : null,
                            ),
                            child: Row(
                              spacing: 14,
                              children: [
                                Icon(rows[i].$1, size: 20),
                                Expanded(child: Text(rows[i].$2, style: AppText.ui(15))),
                                const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.outline),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                QCard(
                  radius: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    spacing: 14,
                    children: [
                      const Icon(Icons.language_rounded, size: 20),
                      Expanded(child: Text(l10n.language, style: AppText.ui(15))),
                      const LangSwitch(long: true),
                    ],
                  ),
                ),
                if (kDebugMode || const bool.fromEnvironment('DEV_MENU')) ...[
                  const SizedBox(height: 14),
                  QCard(
                    radius: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Text(l10n.homeVariant, style: AppText.ui(13, color: AppColors.muted)),
                        Segmented(
                          height: 40,
                          track: AppColors.bg,
                          value: ref.watch(homeVariantProvider),
                          onChanged: (v) => ref.read(homeVariantProvider.notifier).set(v),
                          options: const [(HomeVariant.bento, '1a'), (HomeVariant.catalog, '1b'), (HomeVariant.editorial, '1c')],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
