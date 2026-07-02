import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class DeviceIdService {
  static const String _key = "device_id";

  Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();

    String? id = prefs.getString(_key);

    if (id != null) {
      return id;
    }

    id = _generateId();

    await prefs.setString(_key, id);

    return id;
  }

  String _generateId() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    final random = Random();

    return "TH-" +
        List.generate(
          6,
          (_) => chars[random.nextInt(chars.length)],
        ).join();
  }
}