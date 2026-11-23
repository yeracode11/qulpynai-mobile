import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../data/models/models.dart';
import '../../features/cart/cart_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_gloss.dart';
import '../theme/app_text.dart';
import '../utils/format.dart';
import '../utils/l10n.dart';
import 'async_view.dart';
import 'buttons.dart';
import 'visuals.dart';

void addToCartWithToast(BuildContext context, WidgetRef ref, Product p) {
  HapticFeedback.lightImpact();
  ref.read(cartProvider.notifier).add(p);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('${context.l10n.addedToCart}: ${context.tr(p.name)}', maxLines: 2, overflow: TextOverflow.ellipsis),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(label: context.l10n.goToCart, textColor: AppColors.white, onPressed: () => context.push('/cart')),
      ),
    );
}

/// Two-column grid card (design 1i).
class ProductGridCard extends ConsumerWidget {
  const ProductGridCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), boxShadow: AppGloss.card),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.push('/product/${product.id}'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(18)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ProductPhoto(asset: product.image, size: 124),
                      PositionedDirectional(
                        top: 0,
                        end: 0,
                        child: IconButton(
                          tooltip: context.l10n.favorite,
                          onPressed: () => showStub(context),
                          icon: const Icon(Icons.favorite_border_rounded, size: 22, color: AppColors.muted),
                        ),
                      ),
                      if (product.isNew)
                        PositionedDirectional(
                          top: 10,
                          start: 10,
                          child: Container(
                            height: 22,
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: AppColors.greenText, borderRadius: BorderRadius.circular(11)),
                            child: Text(
                              l10n.newBadge,
                              style: AppText.ui(10, weight: FontWeight.w700, color: AppColors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 6),
                  child: SizedBox(height: 34, child: Text(context.tr(product.name), maxLines: 2, style: AppText.ui(13, height: 1.25))),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 3,
                          children: [
                            Text(formatTenge(product.price), style: AppText.num(16)),
                            Text(
                              formatWeight(product.weightGrams),
                              style: AppText.ui(11, weight: FontWeight.w500, color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                      AddRoundButton(tooltip: l10n.addToCart, onPressed: () => addToCartWithToast(context, ref, product)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal shelf card (design 1c).
class ProductShelfCard extends ConsumerWidget {
  const ProductShelfCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 156,
      child: GestureDetector(
        onTap: () => context.push('/product/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Container(
              height: 156,
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(24)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ProductPhoto(asset: product.image, size: 128),
                  PositionedDirectional(
                    end: 8,
                    bottom: 8,
                    child: AddRoundButton(tooltip: context.l10n.addToCart, onPressed: () => addToCartWithToast(context, ref, product)),
                  ),
                ],
              ),
            ),
            Text(context.tr(product.name), maxLines: 2, style: AppText.ui(13, height: 1.25)),
            Text(formatTenge(product.price), style: AppText.num(15)),
          ],
        ),
      ),
    );
  }
}

/// Compact row card (design 1a "Хиты недели").
class ProductMiniCard extends StatelessWidget {
  const ProductMiniCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: AppGloss.card),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => context.push('/product/${product.id}'),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              spacing: 10,
              children: [
                ProductPhoto(asset: product.image, size: 52),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(context.tr(product.name), maxLines: 2, style: AppText.ui(12, height: 1.2)),
                      Text(formatTenge(product.price), style: AppText.num(14, color: AppColors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

(Color, Color) categoryColors(CategoryTone tone) => switch (tone) {
  CategoryTone.red => (AppColors.redSoft, AppColors.redDark),
  CategoryTone.teal => (AppColors.tealSoft, AppColors.tealDark),
  CategoryTone.cream => (AppColors.cream, AppColors.brown),
  CategoryTone.green => (AppColors.greenSoft, AppColors.greenDark),
  CategoryTone.white => (AppColors.white, AppColors.ink),
};

/// Big category tile with a photo stand-in (design 1b).
class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = categoryColors(category.tone);
    return DecoratedBox(
      decoration: BoxDecoration(gradient: AppGloss.tint(bg), borderRadius: BorderRadius.circular(24), boxShadow: AppGloss.card),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/menu/category/${category.id}'),
          child: SizedBox(
            height: 150,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Text(context.tr(category.name), style: AppText.heading(17, color: fg, height: 1.2)),
                ),
                PositionedDirectional(
                  end: -14,
                  bottom: -14,
                  width: 110,
                  height: 110,
                  child: StripedPlaceholder(
                    label: context.l10n.photo,
                    shape: BoxShape.circle,
                    a: const Color(0x8CFFFFFF),
                    b: const Color(0x4DFFFFFF),
                    stripe: 8,
                    labelColor: const Color(0x731F1A17),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 2-column grid of category tiles.
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key, required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 150,
      ),
      itemBuilder: (_, i) => CategoryTile(category: categories[i]),
    );
  }
}
