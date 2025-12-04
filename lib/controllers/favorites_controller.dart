import 'package:google_maps_flutter/google_maps_flutter.dart';

class FavoritesController {
  static List<LatLng> favorites = [];

  static void add(LatLng pos) {
    favorites.add(pos);
  }

  static void remove(LatLng pos) {
    favorites.remove(pos);
  }
}
