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
    return await WiFiForIoTPlugin.connect(
      ssid,
      password: password,
      security: NetworkSecurity.WPA,
    );
  }

  Future<String?> getCurrentWifi() async {
    return await WiFiForIoTPlugin.getSSID();
  }
}