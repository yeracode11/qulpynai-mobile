import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qulpynai_mobile/app/app.dart';
import 'package:qulpynai_mobile/app/router.dart';
import 'package:qulpynai_mobile/data/mock/mock_data.dart';

Future<ProviderContainer> _openHome(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer();
  addTearDown(container.dispose);
  await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const QulpynaiApp()));
  appRouter.go('/home');
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400)); // mock latency
  await tester.pump();
  return container;
}

/// Steps the clock in small frames so scroll physics and switchers can run;
/// `pumpAndSettle` would never settle because the slide timer keeps ticking.
Future<void> _frames(WidgetTester tester, Duration total) async {
  const step = Duration(milliseconds: 50);
  for (var t = Duration.zero; t < total; t += step) {
    await tester.pump(step);
  }
}

void main() {
  final first = MockData.promos[0].title.ru;
  final second = MockData.promos[1].title.ru;

  testWidgets('promo carousel advances on its own', (tester) async {
    await _openHome(tester);
    expect(find.text(first), findsOneWidget);
    await _frames(tester, const Duration(milliseconds: 5900));
    expect(find.text(second), findsOneWidget);
    expect(find.text(first), findsNothing);
  });

  testWidgets('promo carousel swipes and opens the promo link', (tester) async {
    await _openHome(tester);
    await tester.drag(find.byType(PageView), const Offset(-300, 0));
    await _frames(tester, const Duration(seconds: 1));
    expect(find.text(second), findsOneWidget);

    await tester.tap(find.byType(PageView), warnIfMissed: false);
    await _frames(tester, const Duration(seconds: 1));
    // Pizza promo opens the pizza category screen.
    expect(MockData.promos[1].link, '/menu/category/18');
    expect(find.text('Пицца'), findsWidgets);
    expect(find.text('Пицца «Пепперони»'), findsOneWidget);
  });
}
