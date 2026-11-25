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
import '../../core/widgets/product_widgets.dart';
import '../../core/widgets/visuals.dart';
import '../../data/providers.dart';
import 'promo_carousel.dart';

/// Home tab. Renders one of the three design directions (1a / 1b / 1c).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(homeVariantProvider)) {
      HomeVariant.bento => const _HomeBento(),
      HomeVariant.catalog => const _HomeCatalog(),
      HomeVariant.editorial => const _HomeEditorial(),
    };
  }
}

/// Address pill shown in the home headers.
class _AddressPill extends ConsumerWidget {
  const _AddressPill();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    final street = profile == null ? '…' : context.tr(profile.address.street);
    return Material(
      color: const Color(0xF0FFFFFF),
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => context.push('/address'),
        child: Container(
          height: 44,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: Row(
            spacing: 8,
            children: [
              const Icon(Icons.place_outlined, size: 18, color: AppColors.red),
              Expanded(
                child: Text(street, style: AppText.ui(14), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── 1a · Bento ─────────────────────────────

class _HomeBento extends ConsumerWidget {
  const _HomeBento();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final top = MediaQuery.paddingOf(context).top;
    final heroHeight = 420.0 + top - 54;
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: tabBarClearance(context)),
        child: Stack(
          children: [
            // Promo stories.
            PromoCarousel(height: heroHeight),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                child: Row(
                  spacing: 10,
                  children: const [
                    Expanded(child: _AddressPill()),
                    LangBadge(background: Color(0xF0FFFFFF)),
                  ],
                ),
              ),
            ),
            // Sheet with bento tiles.
            Container(
              margin: EdgeInsets.only(top: heroHeight - 16),
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              decoration: const BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _BentoTiles(),
                  const SizedBox(height: 18),
                  SectionHeader(title: l10n.hits, action: l10n.all, onAction: () => context.go('/menu')),
                  const SizedBox(height: 12),
                  AsyncView(
                    value: ref.watch(hitsProvider),
                    loadingHeight: 72,
                    builder: (hits) => Row(
                      spacing: 10,
                      children: [for (final p in hits.take(2)) Expanded(child: ProductMiniCard(product: p))],
                    ),
                  ),
                  const SizedBox(height: 22),
                  SectionHeader(title: l10n.categories),
                  const SizedBox(height: 12),
                  AsyncView(
                    value: ref.watch(categoriesProvider),
                    builder: (c) => CategoryGrid(categories: c),
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

class _BentoTiles extends ConsumerWidget {
  const _BentoTiles();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bonus = ref.watch(profileProvider).value?.bonus;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Expanded(
            child: _Tile(
              color: AppColors.redSoft,
              onTap: () => context.push('/custom-cake'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.customCake, style: AppText.heading(20, color: AppColors.redDark, height: 1.2)),
                  const Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ProductPhoto(asset: 'assets/images/product1.png', size: 110),
                  ),
                  Text(
                    l10n.customCakeSub,
                    style: AppText.ui(12, weight: FontWeight.w500, color: AppColors.inkSoft, height: 1.2),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 12,
              children: [
                _Tile(
                  color: AppColors.tealSoft,
                  minHeight: 96,
                  onTap: () {
                    ref.read(fulfilmentProvider.notifier).set(FulfilmentMode.pickup);
                    context.go('/stores');
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text(
                        l10n.pickup,
                        style: AppText.ui(16, weight: FontWeight.w700, color: AppColors.tealDark),
                      ),
                      Text(
                        l10n.pickupSub,
                        style: AppText.ui(12, weight: FontWeight.w500, color: AppColors.tealInk),
                      ),
                    ],
                  ),
                ),
                _Tile(
                  color: AppColors.red,
                  minHeight: 96,
                  onTap: () => context.go('/profile'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.bonuses, style: AppText.ui(12, color: const Color(0xE6FFFFFF))),
                      const SizedBox(height: 18),
                      Text(bonus == null ? '—' : formatThousands(bonus), style: AppText.num(26, color: AppColors.white)),
                    ],
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

class _Tile extends StatelessWidget {
  const _Tile({required this.color, required this.child, required this.onTap, this.minHeight = 204});

  final Color color;
  final Widget child;
  final VoidCallback onTap;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final dark = color.computeLuminance() < .2;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: dark ? AppGloss.fill(color) : AppGloss.tint(color),
        borderRadius: BorderRadius.circular(24),
        boxShadow: dark ? AppGloss.glow(color) : AppGloss.card,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: AppGloss.sheen, borderRadius: BorderRadius.circular(24)),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onTap,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: minHeight),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────── 1b · Catalog-first ────────────────────────────

class _HomeCatalog extends ConsumerWidget {
  const _HomeCatalog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final mode = ref.watch(fulfilmentProvider);
    final street = ref.watch(profileProvider).value?.address.street;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(bottom: tabBarClearance(context)),
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              boxShadow: [BoxShadow(color: Color(0x0D1F1A17), blurRadius: 20, offset: Offset(0, 6))],
            ),
            padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 4, 16, 16),
            child: Column(
              spacing: 12,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    const QLogo(height: 30),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push('/address'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Text(
                              l10n.delivery,
                              style: AppText.ui(11, weight: FontWeight.w500, color: AppColors.muted),
                            ),
                            Row(
                              spacing: 4,
                              children: [
                                Flexible(
                                  child: Text(street == null ? '…' : context.tr(street), style: AppText.ui(15, weight: FontWeight.w700)),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const LangBadge(height: 36, border: AppColors.line),
                  ],
                ),
                Segmented(
                  style: SegmentedStyle.light,
                  height: 44,
                  value: mode,
                  onChanged: (m) {
                    ref.read(fulfilmentProvider.notifier).set(m);
                    if (m == FulfilmentMode.custom) context.push('/custom-cake');
                  },
                  options: [
                    (FulfilmentMode.delivery, l10n.delivery),
                    (FulfilmentMode.pickup, l10n.pickup),
                    (FulfilmentMode.custom, l10n.customShort),
                  ],
                ),
                const _SearchRow(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: AsyncView(
              value: ref.watch(categoriesProvider),
              builder: (c) => CategoryGrid(categories: c),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: Material(
            color: AppColors.bg,
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => context.push('/search'),
              child: Container(
                height: 48,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                child: Row(
                  spacing: 10,
                  children: [
                    const Icon(Icons.search_rounded, size: 18, color: AppColors.muted),
                    Flexible(
                      child: Text(
                        l10n.searchHint,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.ui(14, weight: FontWeight.w500, color: AppColors.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Tooltip(
          message: l10n.filters,
          child: Material(
            color: AppColors.bg,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => context.push('/search'),
              child: const SizedBox.square(dimension: 48, child: Icon(Icons.tune_rounded, size: 20)),
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────── 1c · Editorial ────────────────────────────

class _HomeEditorial extends ConsumerStatefulWidget {
  const _HomeEditorial();

  @override
  ConsumerState<_HomeEditorial> createState() => _HomeEditorialState();
}

class _HomeEditorialState extends ConsumerState<_HomeEditorial> {
  int _chip = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = ref.watch(profileProvider).value;
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final selectedCategory = _chip == 0 || _chip > categories.length ? null : categories[_chip - 1].id;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top + 8, bottom: tabBarClearance(context)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        spacing: 6,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                          ),
                          Text(profile == null ? '…' : context.tr(profile.address.street), style: AppText.ui(13, color: AppColors.muted)),
                        ],
                      ),
                    ),
                    const LangBadge(height: 30),
                  ],
                ),
                const SizedBox(height: 16),
                Text(l10n.greeting(profile == null ? '' : context.tr(profile.name)), style: AppText.heading(34, height: 1.18)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Material(
              color: AppColors.teal,
              borderRadius: BorderRadius.circular(28),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.go('/menu'),
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      PositionedDirectional(
                        end: -60,
                        bottom: -10,
                        height: 200,
                        child: Image.asset('assets/images/baganashil.png', excludeFromSemantics: true),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: SizedBox(
                          width: 190,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Container(
                                height: 26,
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(13)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 6,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                                    ),
                                    Flexible(
                                      child: Text(
                                        l10n.freshTime('06:30'),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppText.ui(11, weight: FontWeight.w700, color: AppColors.tealDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(l10n.freshToday, style: AppText.heading(24, color: AppColors.white, height: 1.15)),
                              const SizedBox(height: 6),
                              Row(
                                spacing: 6,
                                children: [
                                  Text(
                                    l10n.promoCta,
                                    style: AppText.ui(13, weight: FontWeight.w700, color: AppColors.white),
                                  ),
                                  const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.white),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          ChipRow(
            labels: [l10n.all, ...categories.take(4).map((c) => context.tr(c.name))],
            selected: _chip,
            onSelected: (i) => setState(() => _chip = i),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 230,
            child: AsyncView(
              value: ref.watch(productsProvider(selectedCategory)),
              builder: (products) => ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                itemCount: products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) => ProductShelfCard(product: products[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
