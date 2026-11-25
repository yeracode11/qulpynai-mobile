import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/tab_bar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/l10n.dart';
import '../../core/utils/launch.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/visuals.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// 1n — stores map + list with contacts.
class StoresScreen extends ConsumerStatefulWidget {
  const StoresScreen({super.key});

  @override
  ConsumerState<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends ConsumerState<StoresScreen> {
  bool _openOnly = false;
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matches(Store s) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return true;
    return '${s.name} ${s.address.ru} ${s.address.kk}'.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: AppColors.map,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 420 + top,
            child: MapPlaceholder(caption: l10n.mapStub),
          ),
          // Store pins.
          Positioned(left: 80, top: 126 + top, child: _pin(main: true)),
          Positioned(
            left: 230,
            top: 96 + top,
            child: _pin(color: AppColors.red),
          ),
          Positioned(
            left: 200,
            top: 206 + top,
            child: _pin(color: AppColors.red),
          ),
          Positioned(
            left: 300,
            top: 246 + top,
            child: _pin(color: AppColors.muted),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Material(
                color: AppColors.white,
                elevation: 6,
                shadowColor: const Color(0x401F1A17),
                shape: const StadiumBorder(),
                child: TextField(
                  controller: _search,
                  textInputAction: TextInputAction.search,
                  style: AppText.ui(14, weight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: l10n.searchStore,
                    hintStyle: AppText.ui(14, weight: FontWeight.w500, color: AppColors.muted),
                    prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.muted),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(tooltip: l10n.clearSearch, icon: const Icon(Icons.close_rounded, size: 18), onPressed: _search.clear),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: .56,
            minChildSize: .3,
            maxChildSize: .92,
            builder: (context, controller) => Container(
              decoration: const BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: AsyncView(
                value: ref.watch(storesProvider),
                builder: (stores) {
                  final shown = stores.where((s) => (!_openOnly || s.status != StoreStatus.closed) && _matches(s)).toList();
                  return ListView(
                    controller: controller,
                    padding: EdgeInsets.fromLTRB(16, 12, 16, tabBarClearance(context)),
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(color: const Color(0xFFDCD6D0), borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        spacing: 8,
                        children: [
                          QChip(label: l10n.all, selected: !_openOnly, onTap: () => setState(() => _openOnly = false)),
                          QChip(label: l10n.openNow, selected: _openOnly, onTap: () => setState(() => _openOnly = true)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (shown.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(l10n.noStoresFound, style: AppText.bodySmall, textAlign: TextAlign.center),
                        ),
                      for (final s in shown)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _StoreCard(store: s),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pin({bool main = false, Color color = AppColors.red}) {
    if (main) {
      return Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.red,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 3),
        ),
        child: const QLogo(height: 18, color: AppColors.white),
      );
    }
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 3),
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (statusText, statusColor) = switch (store.status) {
      StoreStatus.open => (l10n.openUntil(store.closesAt), AppColors.greenText),
      StoreStatus.closingSoon => (l10n.closesIn('${store.minutesToClose}'), AppColors.orange),
      StoreStatus.closed => (l10n.closed, AppColors.muted),
    };
    return QCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(store.name, style: AppText.ui(16, weight: FontWeight.w700)),
              ),
              Text(
                '${store.distanceKm.toStringAsFixed(1).replaceAll('.', ',')} км',
                style: AppText.num(12, weight: FontWeight.w600, color: AppColors.muted),
              ),
            ],
          ),
          Text(
            context.tr(store.address),
            style: AppText.ui(13, weight: FontWeight.w500, color: AppColors.inkSoft),
          ),
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(statusText, style: AppText.ui(12, color: statusColor)),
              ),
              Tooltip(
                message: l10n.call,
                child: Material(
                  color: AppColors.tealSoft,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => callPhone(context, store.phone),
                    child: const SizedBox.square(dimension: 36, child: Icon(Icons.call_outlined, size: 16, color: AppColors.tealDark)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.ink,
                shape: const StadiumBorder(),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: () => openRoute(context, 'Qulpynai ${store.address.ru}'),
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    child: Text(
                      l10n.route,
                      style: AppText.ui(12, weight: FontWeight.w700, color: AppColors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
