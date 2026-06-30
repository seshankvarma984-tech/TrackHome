import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel {
  final String deviceId;
  final double latitude;
  final double longitude;
  final int battery;
  final bool sharing;
  final Timestamp? updatedAt;

  DeviceModel({
    required this.deviceId,
    required this.latitude,
    required this.longitude,
    required this.battery,
    required this.sharing,
    required this.updatedAt,
  });
    factory DeviceModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return DeviceModel(
      deviceId: id,
      latitude: (data["latitude"] ?? 0).toDouble(),
      longitude: (data["longitude"] ?? 0).toDouble(),
      battery: data["battery"] ?? 0,
      sharing: data["sharing"] ?? false,
      updatedAt: data["updatedAt"],
    );
  }
  }