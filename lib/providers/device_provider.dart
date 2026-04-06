import 'package:flutter/material.dart';
import '../services/tcp_service.dart';

class DeviceProvider extends ChangeNotifier {
  final TcpService _tcpService = TcpService();
  bool isConnected = false;
  bool isConnecting = false;
  Stream<String> get logs => _tcpService.logs;

  Future<void> connectToDevice() async {
    const int retries = 3;

    isConnecting = true;
    isConnected = false;
    notifyListeners();

    for (int i = 0; i < retries; i++) {
      try {
        print("Attempt ${i + 1} to connect TCP...");
        await Future.delayed(const Duration(seconds: 3));

        await _tcpService.connect("192.168.1.144", 333);

        isConnected = true;
        isConnecting = false;
        notifyListeners();

        print("✅ TCP Connected!");
        return;
      } catch (e) {
        print("Attempt ${i + 1} failed: $e");
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    isConnected = false;
    isConnecting = false;
    notifyListeners();

    throw Exception("TCP connection failed");
  }

  Future<void> sendWifiConfig(String ssid, String password) async {
    if (!isConnected) {
      throw Exception("Device not connected via TCP");
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