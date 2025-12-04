import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController {
  static void moveTo(GoogleMapController controller, LatLng pos) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 14),
      ),
    );
  }
}
