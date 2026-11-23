import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current app language: Russian or Kazakh.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('ru');

  void set(Locale locale) => state = locale;
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

/// Three home-screen directions from the design (1a, 1b, 1c).
/// Switchable from Profile in debug builds (or `--dart-define=DEV_MENU=true`),
/// or preset with `--dart-define=HOME_VARIANT=catalog`, so the team can compare them.
enum HomeVariant { bento, catalog, editorial }

class HomeVariantNotifier extends Notifier<HomeVariant> {
  @override
  HomeVariant build() =>
      HomeVariant.values.firstWhere((v) => v.name == const String.fromEnvironment('HOME_VARIANT'), orElse: () => HomeVariant.bento);

  void set(HomeVariant v) => state = v;
}

final homeVariantProvider = NotifierProvider<HomeVariantNotifier, HomeVariant>(HomeVariantNotifier.new);

/// Delivery vs pickup, shared by home and checkout.
enum FulfilmentMode { delivery, pickup, custom }

class FulfilmentNotifier extends Notifier<FulfilmentMode> {
  @override
  FulfilmentMode build() => FulfilmentMode.delivery;

  void set(FulfilmentMode m) => state = m;
}

final fulfilmentProvider = NotifierProvider<FulfilmentNotifier, FulfilmentMode>(FulfilmentNotifier.new);
