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

    await _service.connect(ssid, password);

    connectedWifi = await _service.getCurrentWifi();

    isLoading = false;
    notifyListeners();
  }
}