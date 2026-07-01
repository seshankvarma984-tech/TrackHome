import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/firebase_service.dart';
import '../models/device_model.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final MapController _mapController = MapController();

DeviceModel? trackedDevice;
@override
void initState() {
  super.initState();

  _firebaseService
      .listenToDevice("tracked_phone_001")
      .listen((device) {
    setState(() {
  trackedDevice = device;
});

_mapController.move(
  LatLng(device.latitude, device.longitude),
  _mapController.camera.zoom,
);
  });
}

  @override
  Widget build(BuildContext context) {
    final LatLng location = LatLng(
  trackedDevice?.latitude ?? widget.latitude,
  trackedDevice?.longitude ?? widget.longitude,
);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Location"),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: location,
          initialZoom: 17,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.geofence_app',
          ),

          MarkerLayer(
            markers: [
              Marker(
                point: location,
                width: 60,
                height: 60,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}