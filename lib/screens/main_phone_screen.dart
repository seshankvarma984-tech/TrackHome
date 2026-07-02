import '../services/firebase_service.dart';
import '../widgets/device_card.dart';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import '../models/device_model.dart';
import 'map_screen.dart';

class MainPhoneScreen extends StatefulWidget {
  const MainPhoneScreen({super.key});

  @override
  State<MainPhoneScreen> createState() => _MainPhoneScreenState();
}

class _MainPhoneScreenState extends State<MainPhoneScreen> {
  final Battery _battery = Battery();
  final FirebaseService _firebaseService = FirebaseService();
  int batteryLevel = 0;

 List<DeviceModel> trackeddevices = [];
 DeviceModel? get firstDevice =>
    trackeddevices.isNotEmpty
        ? trackeddevices.first
        : null;
  @override
  void initState() {
    super.initState();
    _firebaseService
    .listenToDevices()
    .listen((devices) {
  setState(() {
    trackeddevices = devices;
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    colors: [Color(0xFF00C2FF), Color(0xFF0066FF)],
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
                      firstDevice?.sharing == true
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
                            firstDevice?.sharing == true
                                ? Icons.location_on
                                : Icons.location_off,
                            color: firstDevice?.sharing == true
                                ? Colors.green
                                : Colors.red,
                            size: 34,
                          ),
                        ),

                        const SizedBox(width: 18),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                firstDevice?.sharing == true
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
                                "Battery : ${firstDevice?.battery ?? 0}%",
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

              const Text(
                "Connected Devices",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

        Column(
  children: trackeddevices.map((device) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DeviceCard(
        deviceName: device.deviceId,
        battery: device.battery,
        online: device.sharing,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MapScreen(
                latitude: device.latitude,
                longitude: device.longitude,
              ),
            ),
          );
        },
      ),
    );
  }).toList(),
),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
