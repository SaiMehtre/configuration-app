import 'package:flutter/material.dart';
import '../services/tcp_service.dart';

class DeviceProvider extends ChangeNotifier {
  final TcpService _tcpService = TcpService();

  bool isConnected = false;
  bool isConnecting = false;

  Future<void> connectToDevice({int retries = 3}) async {
    if (isConnecting) return;
    isConnecting = true;
    notifyListeners();

    for (int i = 0; i < retries; i++) {
      try {
        await _tcpService.connect("192.168.1.144", 333);
        isConnected = true;
        isConnecting = false;
        notifyListeners();
        print("✅ TCP Connected");
        return;
      } catch (e) {
        print("⚠ TCP connect attempt ${i + 1} failed: $e");
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    isConnected = false;
    isConnecting = false;
    notifyListeners();
    throw Exception("TCP connect failed after $retries attempts");
  }

  Future<void> sendWifiConfig(String ssid, String password) async {
    if (!isConnected) {
      throw Exception("Device not connected");
    }

    final command = {
      "cmd": "wifi_config",
      "ssid": ssid,
      "password": password,
      "security": "WPA2"
    };

    await _tcpService.sendCommand(command);
  }
}