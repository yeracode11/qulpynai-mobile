import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/tab_bar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/l10n.dart';
import '../../core/widgets/async_view.dart';
import '../../core/widgets/product_widgets.dart';
import '../../data/providers.dart';

/// Menu tab: search + category tiles (pattern from 1b).
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 4, 16, tabBarClearance(context)),
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4),
            child: Text(l10n.tabMenu, style: AppText.heading(30, height: 1.2)),
          ),
          const SizedBox(height: 16),
          Material(
            color: AppColors.white,
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
                    Text(
                      l10n.searchHint,
                      style: AppText.ui(14, weight: FontWeight.w500, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: AppColors.redSoft,
            borderRadius: BorderRadius.circular(24),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 6),
              title: Text(l10n.customCake, style: AppText.heading(18, color: AppColors.redDark)),
              subtitle: Text(
                l10n.customCakeSub,
                style: AppText.ui(12, weight: FontWeight.w500, color: AppColors.inkSoft),
              ),
              trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.redDark),
              onTap: () => context.push('/custom-cake'),
            ),
          ),
          const SizedBox(height: 12),
          AsyncView(
            value: ref.watch(categoriesProvider),
            onRetry: () => ref.invalidate(categoriesProvider),
            builder: (c) => CategoryGrid(categories: c),
          ),
        ],
      ),
    );
  }
}
