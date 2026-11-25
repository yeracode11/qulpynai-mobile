import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/tab_bar.dart';
import '../../core/widgets/visuals.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/product_widgets.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

/// 1i — category with sub-category chips and a product grid.
class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  int _chip = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = ref.watch(categoriesProvider).value ?? const <Category>[];
    final category = categories.where((c) => c.id == widget.categoryId).firstOrNull;
    final subs = category?.subcategories ?? const <LocalizedText>[];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              title: category == null ? '' : context.tr(category.name),
              actions: [
                CircleIconButton(
                  icon: Icons.search_rounded,
                  tooltip: l10n.searchHint,
                  onPressed: () => context.push('/search?category=${widget.categoryId}'),
                ),
              ],
            ),
            if (subs.isNotEmpty) ...[
              const SizedBox(height: 14),
              ChipRow(
                height: 38,
                labels: [l10n.all, ...subs.map(context.tr)],
                selected: _chip,
                onSelected: (i) => setState(() => _chip = i),
              ),
            ],
            Expanded(
              child: AsyncView(
                value: ref.watch(productsProvider(widget.categoryId)),
                builder: (products) => GridView.builder(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, tabBarClearance(context)),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 276,
                  ),
                  itemBuilder: (_, i) => ProductGridCard(product: products[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
