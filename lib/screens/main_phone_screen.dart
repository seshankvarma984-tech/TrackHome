import '../services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';
import '../services/location_service.dart';
import '../widgets/info_card.dart';

class MainPhoneScreen extends StatefulWidget {
  const MainPhoneScreen({super.key});

  @override
  State<MainPhoneScreen> createState() => _MainPhoneScreenState();
}

class _MainPhoneScreenState extends State<MainPhoneScreen> {
  final Battery _battery = Battery();
  final FirebaseService _firebaseService = FirebaseService();
  final LocationService _locationService = LocationService();

  int batteryLevel = 0;

  bool isSharing = false;
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
});
    loadBattery();
  }

  Future<void> loadBattery() async {
    final level = await _battery.batteryLevel;

    setState(() {
      batteryLevel = level;
    });
  }

  Future<void> uploadLocation() async {
    final position = await _locationService.getCurrentLocation();

    if (position == null) return;

    await FirebaseFirestore.instance
        .collection("users")
        .doc("roshan")
        .set({
      "latitude": position.latitude,
      "longitude": position.longitude,
      "battery": batteryLevel,
      "sharing": isSharing,
      "updatedAt": DateTime.now().toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081420),

      appBar: AppBar(
        backgroundColor: const Color(0xFF081420),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "TrackHome",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
  width: double.infinity,
  padding: const EdgeInsets.all(22),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xFF00C2FF),
        Color(0xFF0066FF),
      ],
    ),
    borderRadius: BorderRadius.circular(24),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        "MAIN PHONE",
        style: TextStyle(
          color: Colors.white70,
          letterSpacing: 2,
          fontSize: 12,
        ),
      ),

      const SizedBox(height: 10),

      Text(
        trackedDevice?.sharing == true
    ? "Live Tracking Enabled"
    : "Live Tracking Disabled",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 20),

      Row(
        children: [

          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              trackedDevice?.sharing == true
                  ? Icons.location_on
                  : Icons.location_off,
              color: trackedDevice?.sharing == true
                  ? Colors.green
                  : Colors.red,
              size: 34,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  trackedDevice?.sharing == true
    ? "Location Visible"
    : "Location Hidden",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Battery : ${trackedDevice?.battery ?? 0}%",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    ],
  ),
),

const SizedBox(height: 25),

InfoCard(
  icon: Icons.gps_fixed,
  title: "GPS",
  subtitle: "High Accuracy",
),

InfoCard(
  icon: Icons.security,
  title: "Geofence",
  subtitle: "Ready",
),

InfoCard(
  icon: Icons.battery_full,
  title: "Battery",
  subtitle: "${trackedDevice?.battery ?? 0}%",
),

const SizedBox(height: 30),

SizedBox(
  width: double.infinity,
  height: 58,
  child: ElevatedButton(

    onPressed: () async {

      setState(() {
        isSharing = !isSharing;
      });

      if (isSharing) {
        await uploadLocation();
      }

    },

    style: ElevatedButton.styleFrom(
      backgroundColor: isSharing
          ? Colors.red
          : const Color(0xFF00C2FF),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
    ),

    child: Text(
      isSharing
          ? "STOP SHARING"
          : "START SHARING",
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
),

const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}