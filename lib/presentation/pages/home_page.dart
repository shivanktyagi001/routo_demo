import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:routo_demo/controllers/location_controller.dart';
import 'package:routo_demo/controllers/favorites_controller.dart';
import 'package:routo_demo/controllers/weather_controller.dart';
import 'package:routo_demo/core/distance.dart';
import 'package:routo_demo/core/heatmap_generator.dart';
import 'package:routo_demo/data/models/weather.dart';
import 'package:routo_demo/presentation/widgets/weather_card.dart';
import 'package:routo_demo/presentation/pages/favorites_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;

  LatLng? current;             // User location
  LatLng? firstTap;            // For distance measurement
  LatLng? secondTap;

  Weather? tappedWeather;      // Weather at tapped point

  bool darkMode = false;
  bool showHeatmap = false;

  Set<Marker> markers = {};
  Set<Circle> heatCircles = {};

  double distanceKm = 0;

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  Future<void> initLocation() async {
    current = await LocationController.currentLocation();

    if (current == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enable GPS permissions")),
      );
      return;
    }

    markers.add(
      Marker(
        markerId: const MarkerId("me"),
        position: current!,
        infoWindow: const InfoWindow(title: "You are here"),
      ),
    );

    // Generate beautiful heatmap circles
    heatCircles = HeatmapGenerator.generateHeatCircles(current!);

    setState(() {});
  }

  /// USER TAPS → WEATHER + DISTANCE LOGIC
  Future<void> onTap(LatLng pos) async {
    tappedWeather = await WeatherController.get(pos.latitude, pos.longitude);

    markers.removeWhere((m) => m.markerId.value == "tap");
    markers.add(Marker(markerId: const MarkerId("tap"), position: pos));

    // Distance calculation logic
    if (firstTap == null) {
      firstTap = pos;
      secondTap = null;
      distanceKm = 0;
    } else {
      secondTap = pos;
      distanceKm = DistanceHelper.calculateDistance(
        firstTap!.latitude,
        firstTap!.longitude,
        secondTap!.latitude,
        secondTap!.longitude,
      );
    }

    setState(() {});
  }

  /// LONG PRESS → SAVE TO FAVORITES
  void onLongPress(LatLng pos) {
    FavoritesController.add(pos);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved to Favorites")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: darkMode?Text("Routo Demo",style: TextStyle(color: Colors.white54),):Text("Routo Demo",style: TextStyle(color: Colors.black),),
        backgroundColor: darkMode ? Colors.black : Colors.blue,
        actions: [

          // HEATMAP TOGGLE
          IconButton(
            icon: Icon(Icons.whatshot,
                color: showHeatmap ? Colors.orange : Colors.white),
            onPressed: () {
              setState(() => showHeatmap = !showHeatmap);
            },
          ),

          // FAVORITES PAGE
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesPage(
                    onSelect: (pos) {
                      mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(pos, 15),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // DARK MODE TOGGLE
          IconButton(
            icon: Icon(
              darkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
            onPressed: () => setState(() => darkMode = !darkMode),
          ),
        ],
      ),

      body: current == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            onMapCreated: (c) => mapController = c,
            initialCameraPosition: CameraPosition(
              target: current!,
              zoom: 15,
            ),
            myLocationEnabled: true,
            markers: markers,

            // 🔥 HEATMAP DRAWN AS CIRCLES
            circles: showHeatmap ? heatCircles : {},

            onTap: onTap,
            onLongPress: onLongPress,

            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
              ),
            },
          ),

          _buildBottomPanel(),
        ],
      ),
    );
  }

  /// BOTTOM PANEL UI
  Widget _buildBottomPanel() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: darkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top drag indicator
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: darkMode ? Colors.white54 : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),

            // WEATHER CARD
            if (tappedWeather != null)
              WeatherCard(
                title: "Selected Location",
                weather: tappedWeather!,
              ),

            const SizedBox(height: 8),

            // DISTANCE TEXT
            if (secondTap != null)
              Text(
                "Distance: ${distanceKm.toStringAsFixed(2)} km",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkMode ? Colors.white : Colors.black,
                ),
              )
            else if (firstTap != null)
              const Text(
                "Tap another point to measure distance",
                style: TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
