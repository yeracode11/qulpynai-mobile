import 'package:flutter/widgets.dart';

import '../../data/models/localized_text.dart';
import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Picks the backend text for the current app language.
  String tr(LocalizedText text) => text.resolve(Localizations.localeOf(this).languageCode);
}
