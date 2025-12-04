import '../data/weather_api.dart';
import '../data/models/weather.dart';

class WeatherController {
  static Future<Weather> get(double lat, double lng) async {
    return WeatherAPI.getWeather(lat, lng);
  }
}
