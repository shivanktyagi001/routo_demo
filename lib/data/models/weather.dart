

class Weather {
  final String main;
  final double temp;

  Weather({required this.main, required this.temp});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      main: json["weather"][0]["main"],
      temp: json["main"]["temp"].toDouble(),
    );
  }
}
