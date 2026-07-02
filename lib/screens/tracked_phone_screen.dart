import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import '../utils/device_id_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/location_service.dart';
import '../services/firebase_service.dart';
import '../widgets/info_card.dart';

class TrackedPhoneScreen extends StatefulWidget {
  const TrackedPhoneScreen({super.key});

  @override
  State<TrackedPhoneScreen> createState() =>
      _TrackedPhoneScreenState();
}

class _TrackedPhoneScreenState
    extends State<TrackedPhoneScreen> {

  final Battery _battery = Battery();
  final LocationService _locationService = LocationService();
final FirebaseService _firebaseService = FirebaseService();
final DeviceIdService _deviceIdService = DeviceIdService();

String deviceId = "";

  int batteryLevel = 0;

  bool isSharing = false;
  Timer? uploadTimer;

  @override
void initState() {
  super.initState();
  loadBattery();
  loadDeviceId();
  loadSharingState();
}

  Future<void> loadBattery() async {
    batteryLevel = await _battery.batteryLevel;

    setState(() {});
  }
  Future<void> loadDeviceId() async {
  deviceId = await _deviceIdService.getDeviceId();

  setState(() {});
}
  Future<void> saveSharingState(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool("sharing_enabled", value);
}

Future<void> loadSharingState() async {
  final prefs = await SharedPreferences.getInstance();

  isSharing = prefs.getBool("sharing_enabled") ?? false;

  setState(() {});

  if (isSharing) {
    startTracking();
  }
}
void startTracking() {
  uploadTimer?.cancel();

  uploadTimer = Timer.periodic(
    const Duration(seconds: 5),
    (_) async {
      final position =
          await _locationService.getCurrentLocation();

      if (position == null) return;

      await _firebaseService.uploadDeviceData(
        deviceId: deviceId,
        latitude: position.latitude,
        longitude: position.longitude,
        battery: batteryLevel,
        sharing: true,
      );
    },
  );
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
          "Tracked Phone",
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
            children: [
                Container(
  width: double.infinity,
  padding: const EdgeInsets.all(22),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xFF00C853),
        Color(0xFF009624),
      ],
    ),
    borderRadius: BorderRadius.circular(24),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        "TRACKED DEVICE",
        style: TextStyle(
          color: Colors.white70,
          letterSpacing: 2,
          fontSize: 12,
        ),
      ),

      const SizedBox(height: 10),

      Text(
        isSharing
            ? "🟢 Sharing Location"
            : "🔴 Sharing Stopped",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 18),

      Row(
        children: [

          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              isSharing
                  ? Icons.location_on
                  : Icons.location_off,
              color: isSharing
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

                const Text(
                  "Tracked Phone",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
const Text(
  "Tracked Phone",
  style: TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 4),

Text(
  deviceId.isEmpty
      ? "Generating ID..."
      : deviceId,
  style: const TextStyle(
    color: Colors.white70,
    fontSize: 13,
  ),
),

const SizedBox(height: 4),

Text(
  "Battery : $batteryLevel %",
  style: const TextStyle(
    color: Colors.white70,
  ),
),              ],
            ),
          ),
        ],
      ),
    ],
  ),
),

const SizedBox(height: 24),

InfoCard(
  icon: Icons.gps_fixed,
  title: "GPS",
  subtitle: "High Accuracy",
),

InfoCard(
  icon: Icons.battery_full,
  title: "Battery",
  subtitle: "$batteryLevel %",
),

InfoCard(
  icon: Icons.cloud_upload,
  title: "Firebase",
  subtitle: isSharing
      ? "Connected"
      : "Waiting",
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
  await saveSharingState(isSharing);

  if (isSharing) {

 startTracking();
} else {

  uploadTimer?.cancel();

}

},
    style: ElevatedButton.styleFrom(
      backgroundColor:
          isSharing
              ? Colors.red
              : Colors.green,

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
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

const SizedBox(height: 20),
SizedBox(
  width: double.infinity,
  height: 58,
  child: ElevatedButton(
    onPressed: () async {
      await _firebaseService.pairDevice(
        parentId: "test_parent",
        deviceId: deviceId,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Device paired successfully!"),
          ),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    child: const Text(
      "PAIR WITH PARENT",
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
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
  @override
void dispose() {
  uploadTimer?.cancel();
  super.dispose();
}
}