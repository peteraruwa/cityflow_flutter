import 'dart:math';

double distanceKm({
  required double fromLat,
  required double fromLon,
  required double toLat,
  required double toLon,
}) {
  const earthRadiusKm = 6371.0;
  final dLat = _radians(toLat - fromLat);
  final dLon = _radians(toLon - fromLon);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_radians(fromLat)) *
          cos(_radians(toLat)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  return earthRadiusKm * 2 * atan2(sqrt(a), sqrt(1 - a));
}

double _radians(double degrees) => degrees * pi / 180;
