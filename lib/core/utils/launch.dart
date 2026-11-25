import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import 'l10n.dart';

/// Contacts from qulpynai.kz (site footer / orders page).
abstract final class Contacts {
  static const phone = '+77471111818';
  static const whatsapp = '77087085599';
  static const email = 'feedback@qulpynai.kz';
}

/// Opens [uri] in another app (dialer, WhatsApp, maps, mail). Shows a
/// snackbar when nothing on the phone can handle it.
Future<void> openExternal(BuildContext context, Uri uri) async {
  final messenger = ScaffoldMessenger.of(context);
  final message = context.l10n.couldNotOpen;
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Exception {
    opened = false;
  }
  if (!opened) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

Future<void> callPhone(BuildContext context, String phone) => openExternal(context, Uri(scheme: 'tel', path: phone));

Future<void> openWhatsApp(BuildContext context, {String? text}) =>
    openExternal(context, Uri.https('wa.me', '/${Contacts.whatsapp}', {'text': ?text}));

/// 2GIS route to an address in Almaty; falls back to the browser if 2GIS isn't installed.
Future<void> openRoute(BuildContext context, String address) =>
    openExternal(context, Uri.https('2gis.kz', '/almaty/search/${Uri.encodeComponent(address)}'));
