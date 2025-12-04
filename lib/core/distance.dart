import 'dart:math';

class DistanceHelper {
  static double calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Earth's radius in KM
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat/2) * sin(dLat/2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon/2) * sin(dLon/2);

    final c = 2 * atan2(sqrt(a), sqrt(1-a));

    return R * c; // distance in KM
  }

  static double _toRadians(double deg) => deg * pi / 180;
}
