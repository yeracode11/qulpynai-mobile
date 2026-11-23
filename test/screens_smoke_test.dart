import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qulpynai_mobile/app/app.dart';
import 'package:qulpynai_mobile/app/router.dart';
import 'package:qulpynai_mobile/core/state/app_state.dart';

/// Opens every route on a 390×844 phone in both languages and fails on any
/// layout overflow or build exception.
Future<void> _loadFonts() async {
  final families = {
    'Raleway': ['Raleway-400', 'Raleway-500', 'Raleway-600', 'Raleway-700'],
    'Lora': ['Lora-500', 'Lora-600', 'Lora-700'],
    'Gilroy': ['Gilroy-SemiBold', 'Gilroy-Bold'],
    'GilroyTenge': ['Gilroy-Tenge'],
  };
  for (final MapEntry(key: family, value: files) in families.entries) {
    final loader = FontLoader(family);
    for (final f in files) {
      loader.addFont(rootBundle.load('assets/fonts/$f.ttf'));
    }
    await loader.load();
  }
}

void main() {
  setUpAll(_loadFonts);
  const routes = [
    '/onboarding',
    '/login',
    '/otp?phone=%2B77071234567',
    '/home',
    '/menu',
    '/menu/category/cakes',
    '/product/medovik',
    '/product/medovik/reviews',
    '/custom-cake',
    '/cart',
    '/checkout',
    '/payment',
    '/address',
    '/stores',
    '/profile',
    '/profile/orders',
  ];

  for (final lang in ['ru', 'kk']) {
    for (final route in routes) {
      testWidgets('$route [$lang]', (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final container = ProviderContainer();
        addTearDown(container.dispose);
        container.read(localeProvider.notifier).set(Locale(lang));
        await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const QulpynaiApp()));
        appRouter.go(route);
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final variant in HomeVariant.values) {
    testWidgets('home variant ${variant.name}', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(homeVariantProvider.notifier).set(variant);
      await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const QulpynaiApp()));
      appRouter.go('/home');
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
    });
  }
}
