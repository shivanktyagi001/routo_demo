import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
class HeatmapGenerator {
  static Set<Circle> generateHeatCircles(LatLng center) {
    final random = Random();
    List<Circle> circles = [];

    for (int i = 0; i < 40; i++) {
      double latOffset = (random.nextDouble() - 0.5) / 300;
      double lngOffset = (random.nextDouble() - 0.5) / 300;
      double intensity = random.nextDouble();

      Color color;

      if (intensity < 0.33) {
        color = Colors.green.withOpacity(0.4);
      } else if (intensity < 0.66) {
        color = Colors.yellow.withOpacity(0.5);
      } else {
        color = Colors.red.withOpacity(0.6);
      }

      circles.add(
        Circle(
          circleId: CircleId("heat_$i"),
          center: LatLng(center.latitude + latOffset, center.longitude + lngOffset),
          radius: 80 + intensity * 80,
          fillColor: color,
          strokeWidth: 0,
        ),
      );
    }

    return circles.toSet(); // Convert List → Set
  }
}
