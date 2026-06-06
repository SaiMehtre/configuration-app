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

  Future<void> refreshConnectedWifi() async {
    String? wifi = await _service.getCurrentWifi();

    if (wifi != null) {
      wifi = wifi.replaceAll('"', '').trim();

      /// ignore temporary invalid values
      if (wifi.isEmpty ||
          wifi.toLowerCase() == "unknown ssid" ||
          wifi.toLowerCase() == "<unknown ssid>") {
        return;
      }

      connectedWifi = wifi;
      notifyListeners();
    }
  }

  Future<void> connectWifi(String ssid, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      await _service.connect(ssid, password);

      // wait max 5 sec for network to be ready
      await Future.delayed(const Duration(seconds: 5));

      String? current = await _service.getCurrentWifi();
      if (current != null && current.replaceAll('"', '').trim().contains(ssid)) {
        connectedWifi = ssid; // correct SSID without quotes
      } else {
        connectedWifi = null;
        throw Exception("Connection Failed"); // triggers snackbar
      }
    } catch (e) {
      connectedWifi = null;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // void clearConnectedWifi() {
  //   connectedWifi = null;
  //   notifyListeners();
  // }
  void clearConnectedWifi() {
    connectedWifi = "Switching Network...";
    notifyListeners();
  }
}