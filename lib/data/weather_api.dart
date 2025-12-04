import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/env.dart';
import 'models/weather.dart';

class WeatherAPI {
  static Future<Weather> getWeather(double lat, double lng) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&units=metric&appid=${Env.weatherKey}";

    final res = await http.get(Uri.parse(url));
    return Weather.fromJson(jsonDecode(res.body));
  }
}
