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
import '../../data/models/models.dart';
import '../../data/providers.dart';
import '../cart/cart_controller.dart';

/// 1e — custom cake: size, inscription, add-ons.
class CustomCakeScreen extends ConsumerStatefulWidget {
  const CustomCakeScreen({super.key});

  @override
  ConsumerState<CustomCakeScreen> createState() => _CustomCakeScreenState();
}

class _CustomCakeScreenState extends ConsumerState<CustomCakeScreen> {
  int _size = 1;
  final _addons = <String>{'candles'};
  final _inscription = TextEditingController();

  @override
  void dispose() {
    _inscription.dispose();
    super.dispose();
  }

  int _total(List<CakeSize> sizes, List<CakeAddon> addons) =>
      sizes[_size].price + addons.where((a) => _addons.contains(a.id)).fold(0, (s, a) => s + a.price);

  void _addToCart(List<CakeSize> sizes, List<CakeAddon> addons) {
    final size = sizes[_size];
    final product = Product(
      id: 'custom-cake',
      categoryId: 'cakes',
      name: LocalizedText('Торт на заказ Ø ${size.diameterCm}', 'Тапсырыспен торт Ø ${size.diameterCm}'),
      price: _total(sizes, addons),
      weightGrams: size.diameterCm * 70,
    );
    ref
        .read(cartProvider.notifier)
        .add(product, keySuffix: '${size.diameterCm}-${_addons.join('+')}-${_inscription.text.hashCode}', note: _inscription.text);
    context.pop();
    context.push('/cart');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sizesAsync = ref.watch(cakeSizesProvider);
    final addonsAsync = ref.watch(cakeAddonsProvider);
    final sizes = sizesAsync.value;
    final addons = addonsAsync.value;
    final ready = sizes != null && addons != null;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                children: [
                  const BackCircleButton(background: AppColors.bg),
                  Expanded(
                    child: Text(
                      l10n.customCake,
                      textAlign: TextAlign.center,
                      style: AppText.ui(17, weight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Expanded(
              child: !ready
                  ? AsyncView(value: sizesAsync, builder: (_) => const SizedBox())
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                      children: [
                        Container(
                          height: 220,
                          decoration: BoxDecoration(color: AppColors.tealSoft, borderRadius: BorderRadius.circular(28)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox.square(
                                dimension: 180,
                                child: StripedPlaceholder(
                                  label: l10n.cakePreview,
                                  shape: BoxShape.circle,
                                  a: const Color(0xB3FFFFFF),
                                  b: const Color(0x59FFFFFF),
                                  labelColor: const Color(0xFF2E6A6A),
                                ),
                              ),
                              PositionedDirectional(
                                start: 14,
                                bottom: 14,
                                child: Container(
                                  height: 28,
                                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14)),
                                  child: Text(
                                    l10n.cakeSizeInfo('${sizes[_size].diameterCm}', sizes[_size].servings),
                                    style: AppText.ui(12, weight: FontWeight.w700, color: AppColors.tealDark),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.size, style: AppText.ui(16, weight: FontWeight.w700)),
                              const SizedBox(height: 10),
                              Row(
                                spacing: 8,
                                children: [
                                  for (var i = 0; i < sizes.length; i++)
                                    Expanded(child: _sizeCard(sizes[i], i == _size, () => setState(() => _size = i))),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Text(l10n.inscription, style: AppText.ui(16, weight: FontWeight.w700)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _inscription,
                                maxLength: 40,
                                textCapitalization: TextCapitalization.sentences,
                                style: AppText.ui(14, weight: FontWeight.w500),
                                decoration: InputDecoration(
                                  hintText: l10n.inscriptionHint,
                                  hintStyle: AppText.ui(14, weight: FontWeight.w500, color: AppColors.muted),
                                  filled: true,
                                  fillColor: AppColors.bg,
                                  counterText: '',
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(l10n.addons, style: AppText.ui(16, weight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              for (var i = 0; i < addons.length; i++)
                                InkWell(
                                  onTap: () => setState(
                                    () => _addons.contains(addons[i].id) ? _addons.remove(addons[i].id) : _addons.add(addons[i].id),
                                  ),
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      border: i < addons.length - 1 ? const Border(bottom: BorderSide(color: AppColors.line)) : null,
                                    ),
                                    child: Semantics(
                                      checked: _addons.contains(addons[i].id),
                                      child: Row(
                                        spacing: 12,
                                        children: [
                                          QCheckbox(checked: _addons.contains(addons[i].id)),
                                          Expanded(child: Text(context.tr(addons[i].name), style: AppText.ui(14))),
                                          Text('+ ${formatTenge(addons[i].price)}', style: AppText.num(14, weight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: PillButton(
                label: l10n.addToCart,
                shadow: true,
                height: 60,
                trailing: ready ? formatTenge(_total(sizes, addons)) : null,
                onPressed: ready ? () => _addToCart(sizes, addons) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sizeCard(CakeSize s, bool selected, VoidCallback onTap) {
    final fg = selected ? AppColors.redDark : AppColors.ink;
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 64,
          decoration: BoxDecoration(
            color: selected ? AppColors.redSoft : AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: selected ? AppColors.red : AppColors.line, width: selected ? 2 : 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Text('Ø ${s.diameterCm}', style: AppText.num(15, color: fg)),
              Text(
                formatTenge(s.price),
                style: AppText.num(11, weight: FontWeight.w600, color: selected ? AppColors.redDark : AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
