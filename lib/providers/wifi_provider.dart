import 'package:flutter/material.dart';
import '../models/wifi_network.dart';
import '../services/wifi_service.dart';

class WifiProvider extends ChangeNotifier {
  List<AppWifiNetwork> networks = [];
  String? connectedWifi;
  bool isLoading = false;

  final WifiService _service = WifiService();

  Future<void> scanWifi() async {
    networks = await _service.scanWifi();
    connectedWifi = await _service.getCurrentWifi();
    notifyListeners();
  }

  Future<void> connectWifi(String ssid, String password) async {
    isLoading = true;
    notifyListeners();

    bool result = await _service.connect(ssid, password);

    // wait for connection to settle
    await Future.delayed(const Duration(seconds: 3));

    String? current = await _service.getCurrentWifi();

    if (current != null && current.contains(ssid)) {
      connectedWifi = current;
    } else {
      connectedWifi = null;
      throw Exception("Wrong password or connection failed");
    }

    isLoading = false;
    notifyListeners();
  }
}