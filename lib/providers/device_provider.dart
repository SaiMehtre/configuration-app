import 'package:flutter/material.dart';
import '../services/tcp_service.dart';

class DeviceProvider extends ChangeNotifier {
  final TcpService _tcpService = TcpService();

  bool isConnected = false;

  Future<void> connectToDevice() async {
    try {
      await _tcpService.connect("192.168.1.144", 333); 
      isConnected = true;
      notifyListeners();
    } catch (e) {
      isConnected = false;
      print("CONNECT ERROR: $e");
      rethrow;
    }
  }

  Future<void> sendWifiConfig(String ssid, String password) async {
    final command = {
      "cmd": "wifi_config",
      "ssid": ssid,
      "password": password,
      "security": "WPA2"
    };

    await _tcpService.sendCommand(command);
  }
}