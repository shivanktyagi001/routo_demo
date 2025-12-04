import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/env.dart';
import 'models/place.dart';

class MapsAPI {
  static String apiKey = Env.mapsKey;

  /// 1) AUTOCOMPLETE: returns a list of Place objects
  static Future<List<Place>> searchPlaces(String query) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
            "?input=$query&key=$apiKey");

    final res = await http.get(url);
    final data = jsonDecode(res.body);

    if (data["status"] != "OK") return [];

    List predictions = data["predictions"];
    List<Place> places = [];

    for (var p in predictions) {
      String placeId = p["place_id"];
      String description = p["description"];

      // Get REAL lat/lng
      final coords = await getPlaceCoordinates(placeId);
      if (coords == null) continue;

      places.add(
        Place(
          name: description,
          lat: coords["lat"],
          lng: coords["lng"],
        ),
      );
    }

    return places;
  }

  /// 2) DETAILS API: fetch lat/lng using place_id
  static Future<Map<String, dynamic>?> getPlaceCoordinates(String placeId) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json"
            "?place_id=$placeId&key=$apiKey");

    final res = await http.get(url);
    final data = jsonDecode(res.body);

    if (data["status"] != "OK") return null;

    final loc = data["result"]["geometry"]["location"];
    return {"lat": loc["lat"], "lng": loc["lng"]};
  }
}
