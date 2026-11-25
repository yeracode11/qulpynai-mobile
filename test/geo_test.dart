import 'package:flutter_test/flutter_test.dart';
import 'package:qulpynai_mobile/core/geo/geo.dart';
import 'package:qulpynai_mobile/data/mock/mock_data.dart';

void main() {
  const square = [GeoPoint(0, 0), GeoPoint(0, 10), GeoPoint(10, 10), GeoPoint(10, 0)];

  test('point in polygon', () {
    expect(pointInPolygon(const GeoPoint(5, 5), square), isTrue);
    expect(pointInPolygon(const GeoPoint(15, 5), square), isFalse);
    expect(pointInPolygon(const GeoPoint(5, -1), square), isFalse);
  });

  test('backend [lat, lng] pairs round-trip', () {
    final p = GeoPoint.fromJson([43.25, 76.93]);
    expect(p, const GeoPoint(43.25, 76.93));
    expect(p.toJson(), [43.25, 76.93]);
  });

  test('distance across Almaty is a few km', () {
    final d = distanceKm(const GeoPoint(43.2380, 76.9455), const GeoPoint(43.2337, 76.9561));
    expect(d, closeTo(0.97, .1));
  });

  test('mock stores and the saved address are inside a delivery zone', () {
    bool covered(GeoPoint p) => MockData.deliveryZones.any((z) => z.contains(p));
    for (final s in MockData.stores) {
      expect(covered(s.location), isTrue, reason: s.name);
    }
    expect(covered(MockData.user.address.location!), isTrue);
    expect(covered(const GeoPoint(43.40, 77.20)), isFalse);
  });
}
