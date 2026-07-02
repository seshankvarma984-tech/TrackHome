import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/main_phone_screen.dart';
import 'screens/tracked_phone_screen.dart';
import 'background/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeService();

  runApp(const MaterialApp(
    home: ModeSelectionScreen(),
  ));
}
class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF081420),
        Color(0xFF0D1B2A),
        Color(0xFF1B263B),
      ],
    ),
  ),
  child: SafeArea(
       child: SingleChildScrollView(
  child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
  'assets/logo.png',
  width: 150,
),

                const SizedBox(height: 20),

                const Text(
                  "TrackHome",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Safety Matters",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 50),

                _buildCard(
  context,
  icon: Icons.phone_android,
  title: "Main Phone",
  subtitle: "Monitor devices",
),

const SizedBox(height: 20),

_buildCard(
  context,
  icon: Icons.location_on,
  title: "Tracked Phone",
  subtitle: "Share location",
),
              ],
            ),
           ),
          ),
         ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
     onTap: () {
  if (title == "Main Phone") {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MainPhoneScreen(),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrackedPhoneScreen(),
      ),
    );
  }
},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
  color: const Color(0xFF1B263B),
  borderRadius: BorderRadius.circular(20),
  border: Border.all(
    color: const Color(0xFF00C2FF).withValues(alpha: 0.25),
    width: 1.2,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ],
),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF00C2FF),
              size: 40,
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
               ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String locationText = "Press the button to get location";

  Future<void> getLocation() async {
    LocationPermission permission =
        await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        locationText = "Location permission denied";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    await FirebaseFirestore.instance
        .collection('locations')
        .add({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'time': DateTime.now().toString(),
    });

    setState(() {
      locationText =
          "Latitude: ${position.latitude}\nLongitude: ${position.longitude}\n\nSaved to Firebase!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Home"),
      ),
      body: Center(
        child: Text(
          locationText,
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getLocation,
        child: const Icon(Icons.location_on),
      ),
    );
  }
}