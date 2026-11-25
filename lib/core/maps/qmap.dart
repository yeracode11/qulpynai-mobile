import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as ym;

import '../../data/models/models.dart';

/// Whether the real Yandex map can be shown: a phone build with a MapKit key.
///
/// The key is read natively (android/local.properties, ios/Flutter/Secrets.xcconfig).
/// Without it, on the web preview and in tests, screens draw their placeholder map.
final mapKitReadyProvider = FutureProvider<bool>((ref) async {
  if (kIsWeb) return false;
  if (defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS) return false;
  try {
    return await const MethodChannel('kz.qulpynai/maps').invokeMethod<bool>('hasKey') ?? false;
  } on MissingPluginException {
    return false;
  } on PlatformException {
    return false;
  }
});

/// A store or other point of interest drawn as a round pin.
class QMapPin {
  const QMapPin({required this.id, required this.point, this.active = true, this.onTap});

  final String id;
  final GeoPoint point;

  /// Red when active, grey otherwise (e.g. a closed store).
  final bool active;
  final VoidCallback? onTap;
}

/// Lets a screen move the camera of a [QMap].
class QMapController {
  ym.YandexMapController? _map;

  /// Whether a real map is attached.
  bool get isLive => _map != null;

  Future<void> moveTo(GeoPoint p, {double zoom = 15}) async {
    await _map?.moveCamera(
      ym.CameraUpdate.newCameraPosition(ym.CameraPosition(target: _pt(p), zoom: zoom)),
      animation: const ym.MapAnimation(duration: .6),
    );
  }

  /// Shows the blue "you are here" dot. Needs location permission first.
  Future<void> showUser() async => _map?.toggleUserLayer(visible: true, autoZoomEnabled: false);
}

ym.Point _pt(GeoPoint p) => ym.Point(latitude: p.lat, longitude: p.lng);

/// Yandex map with delivery zones and pins.
///
/// Shows [fallback] instead when MapKit isn't available (see [mapKitReadyProvider]).
class QMap extends ConsumerWidget {
  const QMap({
    super.key,
    required this.center,
    required this.fallback,
    this.zoom = 13,
    this.zones = const [],
    this.pins = const [],
    this.controller,
    this.onCameraMove,
    this.onCameraIdle,
  });

  final GeoPoint center;
  final double zoom;
  final List<DeliveryZone> zones;
  final List<QMapPin> pins;
  final QMapController? controller;
  final Widget fallback;

  /// Called once when the camera starts moving after being still.
  final VoidCallback? onCameraMove;

  /// Called with the camera's centre when it stops.
  final ValueChanged<GeoPoint>? onCameraIdle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(mapKitReadyProvider).value != true) return fallback;
    var moving = false;
    return ym.YandexMap(
      mode2DEnabled: true,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      nightModeEnabled: false,
      mapObjects: [
        for (final z in zones)
          ym.PolygonMapObject(
            mapId: ym.MapObjectId('zone_${z.id}'),
            polygon: ym.Polygon(
              outerRing: ym.LinearRing(points: [for (final p in z.points) _pt(p)]),
              innerRings: const [],
            ),
            fillColor: Color(z.color).withValues(alpha: .16),
            strokeColor: Color(z.color),
            strokeWidth: 2,
          ),
        for (final pin in pins)
          ym.PlacemarkMapObject(
            mapId: ym.MapObjectId('pin_${pin.id}'),
            point: _pt(pin.point),
            opacity: 1,
            consumeTapEvents: pin.onTap != null,
            onTap: pin.onTap == null ? null : (_, _) => pin.onTap!(),
            icon: ym.PlacemarkIcon.single(
              ym.PlacemarkIconStyle(
                image: ym.BitmapDescriptor.fromAssetImage(
                  pin.active ? 'assets/images/map/store_open.png' : 'assets/images/map/store_closed.png',
                ),
                scale: .6,
              ),
            ),
          ),
      ],
      onMapCreated: (map) async {
        controller?._map = map;
        await map.moveCamera(ym.CameraUpdate.newCameraPosition(ym.CameraPosition(target: _pt(center), zoom: zoom)));
      },
      onCameraPositionChanged: (position, reason, finished) {
        if (!finished) {
          if (!moving) onCameraMove?.call();
          moving = true;
          return;
        }
        moving = false;
        onCameraIdle?.call(GeoPoint(position.target.latitude, position.target.longitude));
      },
    );
  }
}
