import 'dart:math' as math;

/// A point on the map in WGS-84 degrees, the same order the backend stores
/// delivery zones in: `[lat, lng]`.
class GeoPoint {
  const GeoPoint(this.lat, this.lng);

  /// Reads a `[lat, lng]` pair as the backend sends it.
  factory GeoPoint.fromJson(List<dynamic> pair) => GeoPoint((pair[0] as num).toDouble(), (pair[1] as num).toDouble());

  final double lat;
  final double lng;

  List<double> toJson() => [lat, lng];

  /// Almaty city centre, the default camera position (same as the website).
  static const almaty = GeoPoint(43.2567, 76.9286);

  @override
  bool operator ==(Object other) => other is GeoPoint && other.lat == lat && other.lng == lng;

  @override
  int get hashCode => Object.hash(lat, lng);

  @override
  String toString() => 'GeoPoint($lat, $lng)';
}

/// Whether [p] lies inside [polygon] (ray casting, same as the website's
/// `isPointInPolygon`). The polygon's ring may be open or closed.
bool pointInPolygon(GeoPoint p, List<GeoPoint> polygon) {
  var inside = false;
  for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    final a = polygon[i];
    final b = polygon[j];
    final crosses = (a.lng > p.lng) != (b.lng > p.lng) && p.lat < (b.lat - a.lat) * (p.lng - a.lng) / (b.lng - a.lng) + a.lat;
    if (crosses) inside = !inside;
  }
  return inside;
}

/// Great-circle distance between two points, in kilometres.
double distanceKm(GeoPoint a, GeoPoint b) {
  const r = 6371.0;
  double rad(double d) => d * math.pi / 180;
  final dLat = rad(b.lat - a.lat);
  final dLng = rad(b.lng - a.lng);
  final h = math.pow(math.sin(dLat / 2), 2) + math.cos(rad(a.lat)) * math.cos(rad(b.lat)) * math.pow(math.sin(dLng / 2), 2);
  return 2 * r * math.asin(math.sqrt(h));
}
