import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/format.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/visuals.dart';
import '../../data/mock/mock_data.dart';
import '../../data/providers.dart';

/// 1m — delivery zone check on a map. The map itself is a placeholder
/// until 2GIS / Yandex Maps SDK is added.
class AddressMapScreen extends ConsumerWidget {
  const AddressMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final street = ref.watch(profileProvider).value?.address.street;
    final eta = l10n.etaRange('30', '45');
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: MapPlaceholder(caption: l10n.mapStub)),
          // Delivery zone.
          Positioned(
            left: 40,
            right: 50,
            top: 150,
            height: 360,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: .14),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.elliptical(130, 150),
                  topRight: Radius.elliptical(170, 210),
                  bottomRight: Radius.elliptical(150, 180),
                  bottomLeft: Radius.elliptical(120, 150),
                ),
                border: Border.all(color: AppColors.teal, width: 2),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 250,
            child: Column(
              children: [
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    eta,
                    style: AppText.ui(12, weight: FontWeight.w700, color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(Icons.location_on_rounded, size: 56, color: AppColors.red),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                spacing: 12,
                children: [
                  CircleIconButton(icon: Icons.chevron_left_rounded, tooltip: l10n.back, shadow: true, onPressed: () => context.pop()),
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [BoxShadow(color: Color(0x1A1F1A17), blurRadius: 12, offset: Offset(0, 4))],
                    ),
                    child: Text(l10n.mapTitle, style: AppText.ui(15, weight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: CircleIconButton(
                    icon: Icons.near_me_outlined,
                    foreground: AppColors.teal,
                    size: 48,
                    shadow: true,
                    tooltip: l10n.myLocation,
                    onPressed: () => showStub(context),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: SafeArea(
                    top: false,
                    minimum: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 14,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(2)),
                          ),
                        ),
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(18)),
                          child: Row(
                            spacing: 12,
                            children: [
                              const Icon(Icons.search_rounded, size: 18, color: AppColors.muted),
                              Text(street == null ? '…' : context.tr(street), style: AppText.ui(15, weight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(color: AppColors.greenSoft, borderRadius: BorderRadius.circular(18)),
                          child: Row(
                            spacing: 12,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                                child: const Icon(Icons.check_rounded, size: 18, color: AppColors.white),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 4,
                                  children: [
                                    Text(
                                      l10n.inZone,
                                      style: AppText.ui(14, weight: FontWeight.w700, color: AppColors.greenInk),
                                    ),
                                    Text(
                                      l10n.zoneInfo(eta, formatTenge(MockData.freeDeliveryFrom)),
                                      style: AppText.ui(
                                        12,
                                        weight: FontWeight.w500,
                                        color: const Color(0xFF3E5A30),
                                      ).copyWith(fontFamilyFallback: const ['GilroyTenge']),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        PillButton(label: l10n.confirmAddress, onPressed: () => context.pop()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
