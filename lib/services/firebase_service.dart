import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;
        Future<void> uploadDeviceData({
    required String deviceId,
    required double latitude,
    required double longitude,
    required int battery,
    required bool sharing,
  }) async {
    await _firestore
        .collection("tracked_devices")
        .doc(deviceId)
        .set({
      "latitude": latitude,
      "longitude": longitude,
      "battery": battery,
      "sharing": sharing,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }
    Stream<DeviceModel> listenToDevice(
    String deviceId,
  ) {
    return _firestore
        .collection("tracked_devices")
        .doc(deviceId)
        .snapshots()
        .map((snapshot) {
      return DeviceModel.fromFirestore(
        snapshot.id,
        snapshot.data()!,
      );
    });
  }
  }