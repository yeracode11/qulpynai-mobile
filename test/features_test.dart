import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qulpynai_mobile/app/app.dart';
import 'package:qulpynai_mobile/app/router.dart';
import 'package:qulpynai_mobile/features/cart/cart_controller.dart';
import 'package:qulpynai_mobile/features/favorites/favorites_controller.dart';

Future<ProviderContainer> _open(WidgetTester tester, String route) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer();
  addTearDown(container.dispose);
  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const QulpynaiApp()));
  appRouter.go(route);
  await _settle(tester);
  return container;
}

/// Lets mock latency and transitions finish; the home carousel timer means
/// pumpAndSettle can't be used.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('search finds products in Russian and Kazakh and shows an empty state', (tester) async {
    await _open(tester, '/search');
    await tester.enterText(find.byType(TextField), 'пепперони');
    await _settle(tester);
    expect(find.text('Пицца «Пепперони»'), findsOneWidget);
    expect(find.text('Пицца «Маргарита»'), findsNothing);

    await tester.enterText(find.byType(TextField), 'құлпынай торты');
    await _settle(tester);
    expect(find.text('Торт «Клубника»'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'суши');
    await _settle(tester);
    expect(find.text('Ничего не нашли'), findsOneWidget);
  });

  testWidgets('heart on a product card adds it to favorites', (tester) async {
    final container = await _open(tester, '/menu/category/18');
    await tester.tap(find.byTooltip('В избранное').first);
    await _settle(tester);
    expect(container.read(favoritesProvider), isNotEmpty);

    appRouter.go('/favorites');
    await _settle(tester);
    expect(find.text('Здесь пока пусто'), findsNothing);
    expect(find.byTooltip('Убрать из избранного'), findsOneWidget);
  });

  testWidgets('repeat puts a past order back in the cart', (tester) async {
    final container = await _open(tester, '/profile/orders');
    container.read(cartProvider.notifier).clear();
    await tester.tap(find.text('Повторить').hitTestable().first);
    await _settle(tester);
    expect(container.read(cartProvider).lines, isNotEmpty);
  });

  testWidgets('leaving a review adds it to the list', (tester) async {
    await _open(tester, '/product/97/reviews');
    await tester.tap(find.text('Оставить отзыв'));
    await _settle(tester);
    await tester.tap(find.byTooltip('5 из 5'));
    await tester.enterText(find.byType(TextField), 'Самый вкусный торт');
    await tester.pump();
    await tester.tap(find.text('Отправить'));
    await _settle(tester);
    expect(find.text('Самый вкусный торт'), findsOneWidget);
  });
}
