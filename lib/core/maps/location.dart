import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:material_ui/material_ui.dart';

import '../geo/geo.dart';
import '../utils/l10n.dart';

/// Asks for the phone's position, requesting permission if needed.
///
/// Returns null and tells the customer why (location off, access denied)
/// when the position can't be read.
Future<GeoPoint?> locateMe(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  void explain(String text, {bool settings = false}) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          action: settings ? SnackBarAction(label: l10n.openSettings, onPressed: () => Geolocator.openAppSettings()) : null,
        ),
      );
  }

  try {
    if (!await Geolocator.isLocationServiceEnabled()) {
      explain(l10n.locationOff);
      return null;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      explain(l10n.locationDenied, settings: permission == LocationPermission.deniedForever);
      return null;
    }
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium, timeLimit: Duration(seconds: 10)),
      );
      return GeoPoint(pos.latitude, pos.longitude);
    } on TimeoutException {
      // No fresh fix (indoors, or a simulator without a set location): use the last known one.
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return GeoPoint(last.latitude, last.longitude);
      explain(l10n.locationTimeout);
      return null;
    }
  } on Exception catch (e, st) {
    debugPrint('locateMe failed: $e\n$st');
    explain(l10n.locationDenied);
    return null;
  }
}
