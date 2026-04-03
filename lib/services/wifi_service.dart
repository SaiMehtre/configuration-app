import 'package:wifi_iot/wifi_iot.dart';
import '../models/wifi_network.dart';

class WifiService {
  Future<List<AppWifiNetwork>> scanWifi() async {
    final list = await WiFiForIoTPlugin.loadWifiList();

    return list.map((wifi) {
      return AppWifiNetwork(
        ssid: wifi.ssid ?? "",
        isSecure: (wifi.capabilities ?? "").contains("WPA"),
      );
    }).toList();
  }

  Future<bool> connect(String ssid, String password) async {

    // Ensure WiFi is ON before connecting
    await WiFiForIoTPlugin.setEnabled(true);
    
    return await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
      joinOnce: true,
    );
  }

  Future<String?> getCurrentWifi() async {
    return await WiFiForIoTPlugin.getSSID();
  }
}