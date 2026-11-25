import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/chips.dart';
import '../../core/widgets/product_widgets.dart';
import '../../core/widgets/visuals.dart';
import '../../data/models/models.dart';
import '../../data/providers.dart';

enum ProductSort { popular, cheap, expensive }

/// Search across the whole catalog, in both languages, with sorting.
/// Opened from the search fields on Home and Menu and the search icon in a category.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.categoryId});

  /// Limits results to one category when opened from a category screen.
  final String? categoryId;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _query = TextEditingController();
  ProductSort _sort = ProductSort.popular;

  @override
  void initState() {
    super.initState();
    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<Product> _filter(List<Product> all) {
    final q = _query.text.trim().toLowerCase();
    final words = q.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final found = all.where((p) {
      if (widget.categoryId != null && p.categoryId != widget.categoryId) return false;
      final haystack = '${p.name.ru} ${p.name.kk} ${p.description.ru}'.toLowerCase();
      return words.every(haystack.contains);
    }).toList();
    switch (_sort) {
      case ProductSort.popular:
        break;
      case ProductSort.cheap:
        found.sort((a, b) => a.price.compareTo(b.price));
      case ProductSort.expensive:
        found.sort((a, b) => b.price.compareTo(a.price));
    }
    return found;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categories = ref.watch(categoriesProvider).value ?? const <Category>[];
    final scope = categories.where((c) => c.id == widget.categoryId).firstOrNull;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: scope == null ? l10n.searchTitle : '${l10n.searchTitle} · ${context.tr(scope.name)}'),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: TextField(
                controller: _query,
                autofocus: true,
                textInputAction: TextInputAction.search,
                style: AppText.ui(15, weight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  hintStyle: AppText.ui(15, weight: FontWeight.w500, color: AppColors.muted),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
                  suffixIcon: _query.text.isEmpty
                      ? null
                      : IconButton(tooltip: l10n.clearSearch, icon: const Icon(Icons.close_rounded), onPressed: _query.clear),
                  filled: true,
                  fillColor: AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ChipRow(
              height: 38,
              labels: [l10n.sortPopular, l10n.sortCheap, l10n.sortExpensive],
              selected: _sort.index,
              onSelected: (i) => setState(() => _sort = ProductSort.values[i]),
            ),
            if (_query.text.isEmpty && widget.categoryId == null && categories.isNotEmpty) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => QChip(
                    label: context.tr(categories[i].name),
                    selected: false,
                    height: 38,
                    color: AppColors.bgDeep,
                    onTap: () => context.push('/menu/category/${categories[i].id}'),
                  ),
                ),
              ),
            ],
            Expanded(
              child: AsyncView(
                value: ref.watch(productsProvider(null)),
                builder: (all) {
                  final results = _filter(all);
                  if (results.isEmpty) return _NothingFound(onShowAll: _query.clear);
                  return GridView.builder(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 24 + MediaQuery.paddingOf(context).bottom),
                    itemCount: results.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 276,
                    ),
                    itemBuilder: (_, i) => ProductGridCard(product: results[i]),
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

class _NothingFound extends StatelessWidget {
  const _NothingFound({required this.onShowAll});

  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            const Icon(Icons.search_off_rounded, size: 48, color: AppColors.faint),
            Text(l10n.searchEmpty, style: AppText.headline, textAlign: TextAlign.center),
            Text(l10n.searchEmptyHint, style: AppText.bodySmall, textAlign: TextAlign.center),
            TextLink(label: l10n.all, onPressed: onShowAll),
          ],
        ),
      ),
    );
  }
}
