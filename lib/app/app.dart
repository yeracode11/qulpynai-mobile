import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../core/state/app_state.dart';
import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';

class QulpynaiApp extends ConsumerWidget {
  const QulpynaiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Qulpynai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      // material_ui ships its own MaterialLocalizations, so use its delegates
      // rather than the deprecated flutter_localizations ones.
      localizationsDelegates: const [AppLocalizations.delegate, ...GlobalMaterialLocalizations.delegates],
    );
  }
}
