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

    try {
      await _service.connect(ssid, password);

      // wait max 5 sec
      await Future.delayed(const Duration(seconds: 5));

      String? current = await _service.getCurrentWifi();

      if (current != null && current.contains(ssid)) {
        connectedWifi = current;
      } else {
        throw Exception("Connection Failed");
      }
    } catch (e) {
      connectedWifi = null;
      rethrow;
    } finally {
      //  ALWAYS STOP LOADER
      isLoading = false;
      notifyListeners();
    }
  }
}