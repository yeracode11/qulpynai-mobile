import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mock/mock_data.dart';
import '../../data/models/models.dart';

/// One line in the cart. [key] separates the same product in different
/// variants (e.g. 750 g vs 2 kg Medovik, or a custom cake configuration).
class CartLine {
  const CartLine({
    required this.key,
    required this.product,
    required this.unitPrice,
    required this.weightGrams,
    required this.qty,
    this.note,
  });

  final String key;
  final Product product;
  final int unitPrice;
  final int weightGrams;
  final int qty;
  final String? note;

  int get total => unitPrice * qty;

  CartLine copyWith({int? qty}) =>
      CartLine(key: key, product: product, unitPrice: unitPrice, weightGrams: weightGrams, qty: qty ?? this.qty, note: note);
}

class CartState {
  const CartState(this.lines);

  final List<CartLine> lines;

  int get count => lines.fold(0, (s, l) => s + l.qty);
  int get subtotal => lines.fold(0, (s, l) => s + l.total);
  bool get isEmpty => lines.isEmpty;
  int get deliveryFee => subtotal >= MockData.freeDeliveryFrom || isEmpty ? 0 : MockData.deliveryFee;
  int get total => subtotal + deliveryFee;
}

/// Local-only cart. Seeded with the items shown in the design so the
/// cart/checkout screens aren't empty on first launch.
class CartController extends Notifier<CartState> {
  @override
  CartState build() {
    Product p(String id) => MockData.products.firstWhere((e) => e.id == id);
    return CartState([
      CartLine(key: 'medovik-750', product: p('medovik'), unitPrice: 4900, weightGrams: 750, qty: 1),
      CartLine(key: 'ny-cheesecake', product: p('ny-cheesecake'), unitPrice: 1290, weightGrams: 120, qty: 2),
      CartLine(key: 'croissant-almond', product: p('croissant-almond'), unitPrice: 820, weightGrams: 90, qty: 6),
    ]);
  }

  void add(Product product, {ProductVariant? variant, int qty = 1, String? keySuffix, int? unitPrice, String? note}) {
    final weight = variant?.weightGrams ?? product.weightGrams;
    final key = '${product.id}-${keySuffix ?? weight}';
    final lines = [...state.lines];
    final i = lines.indexWhere((l) => l.key == key);
    if (i >= 0) {
      lines[i] = lines[i].copyWith(qty: lines[i].qty + qty);
    } else {
      lines.add(
        CartLine(
          key: key,
          product: product,
          unitPrice: unitPrice ?? variant?.price ?? product.price,
          weightGrams: weight,
          qty: qty,
          note: note,
        ),
      );
    }
    state = CartState(lines);
  }

  void increment(String key) => _update(key, 1);
  void decrement(String key) => _update(key, -1);

  void clear() => state = const CartState([]);

  /// Puts back a previously saved cart (used by "Undo").
  void restore(CartState saved) => state = saved;

  void _update(String key, int delta) {
    final lines = <CartLine>[];
    for (final l in state.lines) {
      if (l.key != key) {
        lines.add(l);
      } else if (l.qty + delta > 0) {
        lines.add(l.copyWith(qty: l.qty + delta));
      }
    }
    state = CartState(lines);
  }
}

final cartProvider = NotifierProvider<CartController, CartState>(CartController.new);
