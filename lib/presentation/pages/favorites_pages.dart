import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/favorites_controller.dart';

class FavoritesPage extends StatelessWidget {
  final Function(LatLng) onSelect;

  const FavoritesPage({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Locations")),
      body: FavoritesController.favorites.isEmpty
          ? const Center(
        child: Text(
          "No favorites yet.\nLong press on map to save one!",
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
          itemCount: FavoritesController.favorites.length,
          itemBuilder: (context, index) {
            final pos = FavoritesController.favorites[index];
            return ListTile(
              title: Text(
                  "Lat: ${pos.latitude.toStringAsFixed(4)}, Lng: ${pos.longitude.toStringAsFixed(4)}"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                onSelect(pos);
                Navigator.pop(context);
              },
              onLongPress: () {
                FavoritesController.remove(pos);
                (context as Element).markNeedsBuild(); // simple refresh
              },
            );
          }),
    );
  }
}
