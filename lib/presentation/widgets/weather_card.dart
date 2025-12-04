import 'package:flutter/material.dart';
import '../../data/models/weather.dart';

class WeatherCard extends StatelessWidget {
  final String title;
  final Weather weather;

  const WeatherCard({
    super.key,
    required this.title,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        title: Text(title),
        subtitle: Text("${weather.main} · ${weather.temp}°C"),
      ),
    );
  }
}
