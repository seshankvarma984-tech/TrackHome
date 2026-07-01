import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final int battery;
  final bool online;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.battery,
    required this.online,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF122033),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          backgroundColor:
              online ? Colors.green : Colors.red,
          child: const Icon(
            Icons.phone_android,
            color: Colors.white,
          ),
        ),

        title: Text(
          deviceName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        subtitle: Text(
          "Battery : $battery%",
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
    );
  }
}