import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';

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
import '../cart/cart_controller.dart';
import '../favorites/favorites_controller.dart';

/// 1d — product sheet: nutrition, tabs, sticky add-to-cart bar.
class ProductScreen extends ConsumerWidget {
  const ProductScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AsyncView(
        value: ref.watch(productProvider(productId)),
        loadingHeight: double.infinity,
        builder: (p) => _ProductBody(product: p),
      ),
    );
  }
}

class _ProductBody extends ConsumerStatefulWidget {
  const _ProductBody({required this.product});

  final Product product;

  @override
  ConsumerState<_ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends ConsumerState<_ProductBody> {
  int _variant = 0;
  int _qty = 1;
  int _tab = 0;

  Product get p => widget.product;

  ProductVariant get _current => p.variants.isEmpty ? ProductVariant(weightGrams: p.weightGrams, price: p.price) : p.variants[_variant];

  void _add() {
    ref.read(cartProvider.notifier).add(p, variant: _current, qty: _qty);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.addedToCart), duration: const Duration(seconds: 1)));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final top = MediaQuery.paddingOf(context).top;
    final photoHeight = 380.0 + top - 54;
    final isFavorite = ref.watch(favoritesProvider.select((f) => f.contains(p.id)));
    final tabs = [l10n.tabComposition, l10n.tabStorage, '${l10n.tabReviews} · ${p.reviewsCount}'];
    // Expand to the full screen so the add-to-cart bar sticks to the bottom
    // even when the content is shorter than the screen.
    return Stack(
      children: [
        const SizedBox.expand(),
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 140),
          child: Stack(
            children: [
              SizedBox(
                height: photoHeight,
                width: double.infinity,
                child: Container(
                  color: AppColors.stripeA,
                  alignment: Alignment.center,
                  child: ProductPhoto(asset: p.image, size: 240),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: photoHeight - 40),
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                decoration: const BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 14,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Expanded(child: Text(context.tr(p.name), style: AppText.heading(26, height: 1.23))),
                        Material(
                          color: AppColors.white,
                          shape: const StadiumBorder(),
                          child: InkWell(
                            customBorder: const StadiumBorder(),
                            onTap: () => context.push('/product/${p.id}/reviews'),
                            child: Container(
                              height: 28,
                              padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 4,
                                children: [
                                  const Icon(Icons.star_rounded, size: 16, color: AppColors.red),
                                  Text(p.rating.toStringAsFixed(1), style: AppText.num(13)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (context.tr(p.description).isNotEmpty)
                      Text(
                        context.tr(p.description),
                        style: AppText.ui(14, weight: FontWeight.w500, color: AppColors.inkSoft, height: 1.43),
                      ),
                    if (p.variants.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: [
                          for (var i = 0; i < p.variants.length; i++)
                            QChip(
                              label: formatWeight(p.variants[i].weightGrams),
                              selected: i == _variant,
                              numeric: true,
                              selectedColor: AppColors.ink,
                              onTap: () => setState(() => _variant = i),
                            ),
                        ],
                      ),
                    if (p.nutrition case final n?) _NutritionCard(n: n),
                    _Tabs(
                      labels: tabs,
                      selected: _tab,
                      onSelected: (i) => i == 2 ? context.push('/product/${p.id}/reviews') : setState(() => _tab = i),
                    ),
                    Text(
                      context.tr(_tab == 0 ? p.composition : p.storage).isEmpty ? '—' : context.tr(_tab == 0 ? p.composition : p.storage),
                      style: AppText.ui(13, weight: FontWeight.w500, color: AppColors.inkSoft, height: 1.46),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(
              spacing: 10,
              children: [
                const BackCircleButton(icon: Icons.close_rounded),
                const Spacer(),
                CircleIconButton(
                  icon: Icons.ios_share_rounded,
                  tooltip: l10n.share,
                  onPressed: () => SharePlus.instance.share(
                    ShareParams(text: '${l10n.shareText(context.tr(p.name), formatTenge(_current.price))}\nhttps://qulpynai.kz'),
                  ),
                ),
                CircleIconButton(
                  icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  foreground: AppColors.red,
                  tooltip: isFavorite ? l10n.removeFavorite : l10n.favorite,
                  onPressed: () => ref.read(favoritesProvider.notifier).toggle(p.id),
                ),
              ],
            ),
          ),
        ),
        // Sticky add-to-cart bar.
        PositionedDirectional(
          start: 16,
          end: 16,
          bottom: 0,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 16),
            child: Container(
              height: 72,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(36),
                boxShadow: const [BoxShadow(color: Color(0x241F1A17), blurRadius: 30, offset: Offset(0, 10))],
              ),
              child: Row(
                spacing: 8,
                children: [
                  QtyStepper(
                    qty: _qty,
                    incrementLabel: l10n.increase,
                    decrementLabel: l10n.decrease,
                    onIncrement: () => setState(() => _qty++),
                    onDecrement: () => setState(() => _qty = _qty > 1 ? _qty - 1 : 1),
                  ),
                  Expanded(
                    child: PillButton(label: l10n.addToCart, trailing: formatTenge(_current.price * _qty), onPressed: _add),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NutritionCard extends StatelessWidget {
  const _NutritionCard({required this.n});

  final Nutrition n;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String d(double v) => v.toStringAsFixed(1).replaceAll('.', ',');
    final cells = [('${n.kcal}', l10n.kcal), (d(n.protein), l10n.protein), (d(n.fat), l10n.fat), (d(n.carbs), l10n.carbs)];
    return QCard(
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(l10n.per100, style: AppText.ui(12, color: AppColors.muted)),
          Row(
            children: [
              for (final (v, label) in cells)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(v, style: AppText.num(17)),
                      Text(
                        label,
                        style: AppText.ui(11, weight: FontWeight.w500, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.labels, required this.selected, required this.onSelected});

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 20,
          children: [
            for (var i = 0; i < labels.length; i++)
              Semantics(
                selected: i == selected,
                button: true,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(i),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: i == selected ? AppColors.red : Colors.transparent, width: 2)),
                    ),
                    child: Text(
                      labels[i],
                      style: AppText.ui(
                        14,
                        weight: i == selected ? FontWeight.w700 : FontWeight.w600,
                        color: i == selected ? AppColors.ink : AppColors.muted,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
