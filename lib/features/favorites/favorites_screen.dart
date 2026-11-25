import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/product_widgets.dart';
import '../../core/widgets/visuals.dart';
import '../../data/providers.dart';
import 'favorites_controller.dart';

/// Products the user hearted, in the order they were added.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ids = ref.watch(favoritesProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: l10n.favorites),
            Expanded(
              child: AsyncView(
                value: ref.watch(productsProvider(null)),
                builder: (all) {
                  final byId = {for (final p in all) p.id: p};
                  final products = [for (final id in ids) ?byId[id]];
                  if (products.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            const Icon(Icons.favorite_border_rounded, size: 48, color: AppColors.faint),
                            Text(l10n.favoritesEmpty, style: AppText.headline, textAlign: TextAlign.center),
                            Text(l10n.favoritesEmptyHint, style: AppText.bodySmall, textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            PillButton(label: l10n.toMenu, onPressed: () => context.go('/menu')),
                          ],
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 24 + MediaQuery.paddingOf(context).bottom),
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 276,
                    ),
                    itemBuilder: (_, i) => ProductGridCard(product: products[i]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
